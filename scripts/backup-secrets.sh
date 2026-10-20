#!/usr/bin/env bash
# Migrate reusable secrets (SSH keys, GPG keys, project env files, keystores)
# between OS installs.
#
#   backup-secrets.sh backup <target-dir> [--dry-run]
#       Copies the files into <target-dir>/files/, records each path (relative
#       to ~) and mode in <target-dir>/manifest.tsv, exports GPG keys, and
#       places a copy of this script in <target-dir>.
#
#   <target-dir>/backup-secrets.sh restore
#       No args: restores everything listed in the manifest next to the script
#       to the same paths under ~, then imports the GPG keys.
#
# Never commit the target dir; keep it on an encrypted drive.
set -euo pipefail

# Nothing is hardcoded per-file. Discovery rules:
#   - everything in ~/.ssh
#   - secret-looking files (by name pattern) in every non-hidden dir under ~
#   - GPG secret keys, if any exist (exported, not copied)
# Directories never descended into (dependencies and build output):
PRUNE=(node_modules .git .next target venv .venv build dist .gradle .dart_tool)

SELF=$(realpath "$0")

die() { echo "error: $*" >&2; exit 1; }

warn() { echo "warning: $*" >&2; }
FAILS=0
LIST=""; STAGE=""
fail() { warn "$*"; FAILS=$((FAILS+1)); }

backup() {
  [[ $# -ge 1 ]] || die "usage: $0 backup <target-dir> [--dry-run]"
  local target dry=0
  target=$(realpath -m "$1"); [[ ${2:-} == --dry-run ]] && dry=1
  case "$target" in "$HOME/dotfyles"*) die "target is inside the dotfyles repo" ;; esac
  if [[ -e $target ]] && [[ ! -d $target || -n $(ls -A "$target") ]]; then
    die "$target exists and is not empty; pick a new directory"
  fi

  cd "$HOME"; umask 077
  LIST=$(mktemp)
  # Build in a staging dir and move it into place only when complete, so a
  # failure or Ctrl-C never leaves a half-written backup at the target.
  trap 'rm -f "$LIST"; [[ -n $STAGE ]] && rm -rf "$STAGE"' EXIT
  trap 'exit 130' INT TERM

  local f d p
  [[ -d .ssh ]] && find .ssh -type f ! -name '*.old' >> "$LIST"

  local dirs=() prune_expr=()
  for d in */; do [[ -d $d ]] && dirs+=("${d%/}"); done   # non-hidden dirs only
  for p in "${PRUNE[@]}"; do prune_expr+=(-name "$p" -o); done
  if ((${#dirs[@]})); then
    find "${dirs[@]}" -maxdepth 6 \( "${prune_expr[@]}" -false \) -prune -o -type f \( \
        -name '.env' -o -name '.env.*' -o -name '*.keystore' -o -name '*.jks' \
        -o -name '*.pem' -o -name 'google-services.json' -o -name 'GoogleService-Info.plist' \
        -o -name 'key.properties' -o -name 'serviceAccount*.json' \) -print 2>/dev/null \
      | grep -vE '\.(example|sample|template)$' \
      | while IFS= read -r f; do   # .pem files only count if they hold a private key
          [[ $f == *.pem ]] && ! grep -q 'PRIVATE KEY' "$f" 2>/dev/null || echo "$f"
        done >> "$LIST" || true
  fi
  sort -u -o "$LIST" "$LIST"

  echo "Files to back up:"; sed 's/^/  /' "$LIST"
  [[ -s $LIST ]] || warn "nothing found to back up"
  ((dry)) && { echo "(dry run, nothing copied)"; return; }

  mkdir -p "$(dirname "$target")"
  STAGE=$(mktemp -d "$(dirname "$target")/.secrets-stage.XXXXXX")
  mkdir -p "$STAGE/files"
  : > "$STAGE/manifest.tsv"

  local mode n=0
  while IFS= read -r f; do
    if [[ -r $f ]] && cp --parents -p "$f" "$STAGE/files/" 2>/dev/null; then
      mode=$(stat -c %a "$f")
      printf '%s\t%s\n' "$mode" "$f" >> "$STAGE/manifest.tsv"; n=$((n+1))
    else
      fail "could not copy $f"
    fi
  done < "$LIST"

  # GPG is best-effort: a cancelled passphrase prompt must not lose the rest.
  if command -v gpg >/dev/null && [[ -n $(gpg --list-secret-keys 2>/dev/null) ]]; then
    mkdir -p "$STAGE/gpg"
    if gpg --export-secret-keys --armor > "$STAGE/gpg/secret-keys.asc" \
       && gpg --export --armor > "$STAGE/gpg/public-keys.asc" \
       && gpg --export-ownertrust > "$STAGE/gpg/ownertrust.txt" \
       && [[ -s $STAGE/gpg/secret-keys.asc ]]; then
      echo "Exported GPG keys"
    else
      rm -rf "$STAGE/gpg"; fail "GPG export failed or was cancelled; re-run to include GPG keys"
    fi
  fi

  cp "$SELF" "$STAGE/backup-secrets.sh"; chmod 700 "$STAGE/backup-secrets.sh" "$STAGE"
  rmdir "$target" 2>/dev/null || true
  mv "$STAGE" "$target"; STAGE=""

  echo "Backed up $n files -> $target"
  echo "Restore on the new install with: $target/backup-secrets.sh restore"
  ((FAILS)) && { echo "Finished with $FAILS problem(s); see warnings above." >&2; exit 1; }
  return 0
}

restore() {
  local src; src=$(dirname "$SELF")
  [[ -f $src/manifest.tsv ]] || die "no manifest.tsv next to this script; run the copy inside the backup dir"
  umask 077; cd "$HOME"
  set +e   # restore never aborts: log each failure and carry on
  local log="$HOME/backup-secrets-restore.log"; : > "$log"
  fail() { warn "$*"; echo "$(date -Is) $*" >> "$log"; FAILS=$((FAILS+1)); }

  local mode f n=0
  while IFS=$'\t' read -r mode f; do
    case "$f" in /*|*..*|"") fail "refusing unsafe manifest path: $f"; continue ;; esac
    [[ $mode =~ ^[0-7]{3,4}$ ]] || { fail "bad mode for $f"; continue; }
    [[ -f $src/files/$f ]] || { fail "missing in backup: $f"; continue; }
    if mkdir -p "$(dirname "$f")" && cp --backup=numbered -p "$src/files/$f" "$f" && chmod "$mode" "$f"; then
      n=$((n+1))   # an existing file is kept as $f.~N~
    else
      fail "could not restore $f"
    fi
  done < "$src/manifest.tsv"
  [[ -d .ssh ]] && chmod 700 .ssh

  if [[ -d $src/gpg ]]; then
    command -v gpg >/dev/null || fail "gpg not installed; install it and re-run restore"
    if command -v gpg >/dev/null; then
      gpg --import "$src/gpg/public-keys.asc" "$src/gpg/secret-keys.asc" || fail "GPG key import failed"
      gpg --import-ownertrust "$src/gpg/ownertrust.txt" || fail "GPG ownertrust import failed"
    fi
  fi
  echo "Restored $n files under $HOME"
  if ((FAILS)); then echo "$FAILS item(s) failed, logged to $log"; else rm -f "$log"; fi
  return 0
}

case "${1:-}" in
  backup)  shift; backup "$@" ;;
  restore) shift; [[ $# -eq 0 ]] || die "restore takes no arguments"; restore ;;
  *) die "usage: $0 backup <target-dir> [--dry-run] | restore" ;;
esac
