# How to Repeat the Model Selection Process

> A reproducible methodology for finding the cost-effective best model per agent in oh-my-opencode-slim.

## Overview

This process evaluates models against **agent-specific capability requirements** rather than generic "best model" rankings. A model that's #1 on MMLU may be wrong for an explorer that just needs fast grep results.

**Time required**: 2-3 hours | **Frequency**: Quarterly or when new models enter the catalog.

---

## Step 1: Inventory Your Model Catalog

List every available model from your provider(s), noting:

- **Provider tier**: Free (`opencode/`) vs paid (`opencode-go/`)
- **Pricing**: Input and output cost per 1M tokens
- **Underlying base model**: What the provider name maps to (e.g., `deepseek-v4-flash` → DeepSeek-V4-Flash 284B/13B MoE)
- **Special capabilities**: Vision, 1M context, tool calling, reasoning mode

**How to get this**: Check your provider's model list endpoint, docs, or config schema.

```bash
# Example: extract model names from config
cat ~/.config/opencode/oh-my-opencode-slim.json | grep '"model"'
```

### Current Model Catalog (as of 2026-06-01)

#### Free Tier (`opencode/`)

| Model | Architecture | Context | SWE-bench V | GPQA | Speed (tok/s) | Vision | Key Trait |
|-------|-------------|---------|-------------|------|---------------|--------|-----------|
| **deepseek-v4-flash-free** | MoE 284B/13B | 1M | 79.0% | 88.1% | 81-130 | No | Best free model |
| **big-pickle** (GLM-4.6) | MoE 355B/32B | 200K† | ~68% | ~81% | Unknown | No | Context degrades >50K |
| **mimo-v2.5-free** | MoE 310B/15B | 1M | ~78.9%‡ | 84.9% | ~93 | Yes (omni) | Free + vision + 1M context |
| **minimax-m3-free** | MoE (unknown) | 1M | Unknown | Unknown | Unknown | Yes (native) | Free + vision + 1M context |
| **nemotron-3-super-free** | Hybrid Mamba+MoE 120B/12B | 1M | 60.5% | 79.2% | ~450 | No | Ultra-fast, weaker accuracy |

†Big Pickle claims 200K context but degrades at 50-70K tokens.
‡MiMo V2.5 SWE-bench figure is from the Pro variant; base V2.5 coding benchmarks are weaker (LiveCodeBench ~39.6%).

#### Paid Tier (`opencode-go/`)

| Model | Architecture | Context | SWE-bench V | GPQA | Speed (tok/s) | Vision | Input/Output $/1M |
|-------|-------------|---------|-------------|------|---------------|--------|-------------------|
| **deepseek-v4-flash** | MoE 284B/13B | 1M | 79.0% | 88.1% | 81-130 | No | $0.14/$0.28 |
| **deepseek-v4-pro** | MoE 1.6T/49B | 1M | 80.6% | 90.1% | 35-169 | No | $1.74/$3.48 |
| **glm-5** | MoE 744B/40B | 200K | 77.8% | 86.0% | 38-212 | No | $1.00/$3.20 |
| **glm-5.1** | MoE ~754B/40B | 200K | 77.8% | 86.2% | 42-186 | No | $1.40/$4.40 |
| **kimi-k2.5** | MoE 1T/32B | 256K | 76.8% | 87.6% | 33-354 | Yes | $0.60/$3.00 |
| **kimi-k2.6** | MoE 1T/32B | 262K | 80.2% | 90.5% | 33-330 | Yes | $0.95/$4.00 |
| **mimo-v2.5** | MoE 310B/15B | 1M | ~78.9%‡ | 84.9% | 93 | Yes (omni) | $0.14/$0.28 |
| **mimo-v2.5-pro** | MoE 1.02T/42B | 1M | 78.9% | ~85% | Unknown | Yes (omni) | $1.74/$3.48 |
| **minimax-m2.5** | MoE ~230B/10B | 197K | 80.2% | 84.8% | 50-100 | API only | $0.30/$1.20 |
| **minimax-m2.7** | MoE 229B/10B | 205K | 78.0% | 87.4% | 58.1 | API only | $0.30/$1.20 |
| **minimax-m3** | MoE (unknown) | 1M | Unknown§ | Unknown | Unknown | Yes (native) | $0.60/$2.40 |
| **qwen3.6-plus** | Hybrid+MoE | 1M | 78.8% | 86.0% | 52 | Yes | $0.50/$3.00 |
| **qwen3.7-max** | MoE ~1T | 1M | 80.4% | 92.4% | 189 | No | $2.50/$7.50 |

‡MiMo V2.5 SWE-bench figure is from the Pro variant; base V2.5 coding benchmarks are weaker (LiveCodeBench ~39.6%).
§MiniMax M3: SWE-bench Pro 59.0%, Terminal-Bench 2.1 66.0%, MCP-Atlas 74.2%, BrowseComp 83.5 — but SWE-bench V, GPQA, IFEval, and speed are unknown.

---

## Step 2: Define Agent Capability Profiles

For each agent in your config, document:

| Dimension | What to Ask |
|-----------|-------------|
| **Primary task** | What does this agent actually do? |
| **Call frequency** | How often is it invoked? (affects cost weight) |
| **Parallelism** | Does it run multiple instances? (cost × N) |
| **Reasoning depth** | Does it need deep chain-of-thought or fast pattern matching? |
| **Speed sensitivity** | Is latency critical (explorer, fixer) or tolerable (oracle)? |
| **Special capabilities** | Vision? Long context? Tool use? Web search? |
| **Output style** | Verbose reasoning or compressed (caveman)? |

### Template

```
Agent: [name]
- Job: [1-2 sentence description]
- Frequency: [low/medium/high]
- Parallelism: [yes/no, typical N]
- Reasoning: [shallow/medium/deep]
- Speed: [critical/important/tolerable]
- Special: [vision/long-context/tool-use/none]
- Output: [verbose/compressed]
```

### Current Agent Profiles (oh-my-opencode-slim)

| Agent | Frequency | Reasoning | Speed | Special | Parallel |
|-------|-----------|-----------|-------|---------|----------|
| Orchestrator | Very High | Medium | Critical | None | No |
| Oracle | Low | Deep | Tolerable | None | No |
| Council | Low-Med | Deep | Tolerable | None | Yes (3-5) |
| Librarian | High | Medium | Important | Web search | No |
| Explorer | Very High | Shallow | Critical | None | Yes (2-4) |
| Designer | Medium | Medium | Important | Vision | No |
| Fixer | Very High | Medium | Critical | None | Yes (2-4) |
| Observer | Medium | Shallow | Important | None | No |

---

## Step 3: Gather Benchmarks per Model

Research each model across these benchmark categories. Use the sources listed below.

### Required Benchmarks

| Category | Benchmarks | Why It Matters |
|----------|-----------|----------------|
| **Coding (basic)** | HumanEval, MBPP+ | Baseline code generation |
| **Coding (agentic)** | SWE-bench Verified, SWE-bench Pro, Terminal-Bench 2.0 | Real-world bug fixing, multi-file edits |
| **Coding (competitive)** | LiveCodeBench, Codeforces | Algorithmic problem-solving |
| **Coding (multi-language)** | Aider Polyglot, MultiPL-E | Cross-language code editing |
| **Reasoning** | GPQA Diamond, MMLU-Pro, AIME | Deep reasoning quality |
| **Instruction following** | IFEval, IFBench | Does the model follow directions? |
| **Tool use** | τ²-Bench, τ³-Bench, Tool-Decathlon | Agent tool-calling accuracy |
| **Retrieval** | BrowseComp, RULER | Search and long-context retrieval |
| **Vision** | OSWorld, MathVision | Visual understanding (designer only) |
| **Speed** | Tokens/second, TTFT | Latency for speed-critical agents |
| **Cost** | $/1M tokens (input + output) | Budget impact |

### Benchmark Sources

| Source | URL | What It Provides |
|--------|-----|-----------------|
| **Artificial Analysis** | artificialanalysis.ai | Speed, cost, quality comparisons across providers |
| **LMArena (LMSYS)** | lmarena.ai | Human preference Elo ratings (general + coding) |
| **Aider Leaderboard** | aider.chat/docs/leaderboards | Polyglot code editing benchmark |
| **LiveCodeBench** | livecodebench.github.io | Contamination-free coding benchmark |
| **SWE-bench** | swe-bench.github.io | Real GitHub issue resolution |
| **Open LLM Leaderboard** | huggingface.co/spaces/open-llm-leaderboard | Standardized open model rankings |
| **GDPval-AA** | github.com/GDPval | Productivity task Elo ratings |
| **Model technical reports** | arxiv, model company blogs | Official benchmark numbers |
| **Code Arena** | arena.ai | WebDev coding Elo |
| **DesignArena** | design-arena.github.io | UI/UX design Elo |

### Research Method

1. **Start with official technical reports** — search for `[model-name] technical report` or `[model-name] benchmark`
2. **Cross-reference with independent benchmarks** — Artificial Analysis, LMArena, Aider
3. **Check Chinese-language sources** for Chinese models — CSDN, 知乎, 量子位 often have head-to-head comparisons
4. **Verify recency** — benchmarks age fast; prefer results from the last 3 months
5. **Note the evaluation setup** — thinking mode vs non-thinking, scaffold type, temperature — these dramatically affect scores

---

## Step 4: Score Models per Agent

For each agent, rank models using a weighted score:

```
Score = w_coding × coding_score + w_reasoning × reasoning_score + w_speed × speed_score + w_cost × cost_score + w_special × special_score
```

### Weight Templates by Agent Type

| Agent Type | Coding | Reasoning | Speed | Cost | Special |
|-----------|--------|-----------|-------|------|---------|
| **Orchestrator** | 20% | 30% | 25% | 25% | 0% |
| **Deep thinker** (Oracle/Council) | 25% | 40% | 10% | 25% | 0% |
| **Search/Retrieval** (Librarian/Explorer) | 15% | 15% | 30% | 40% | 0% |
| **Implementation** (Fixer) | 40% | 15% | 25% | 20% | 0% |
| **Design** (Designer) | 30% | 10% | 15% | 15% | 30% (vision) |
| **Monitor** (Observer) | 10% | 10% | 25% | 55% | 0% |

### Normalization

- **Benchmark scores**: Normalize to 0-1 scale within your model set (min-max normalization)
- **Speed**: Use tokens/second, normalize logarithmically (differences at high speed matter less)
- **Cost**: Use `1 / (input_cost + output_cost)`, normalize. Free models get max score.
- **Special**: Binary (1 if capability present, 0 if not) or benchmark score if available

### Practical Shortcut

If you don't want to compute weighted scores, use this decision tree:

```
1. Is the agent speed-critical? → Pick fastest adequate model
2. Is the agent called frequently? → Pick cheapest adequate model  
3. Does the agent need deep reasoning? → Pick strongest reasoner
4. Does the agent need special capabilities? → Pick model with that capability
5. Otherwise → Pick best cost/quality ratio
```

---

## Step 5: Select and Rank Candidates

For each agent, produce a ranked list:

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | [model] | [why it fits best] | $X/$Y |
| 2nd | [model] | [trade-off vs best] | $X/$Y |
| 3rd | [model] | [trade-off vs best] | $X/$Y |
| 4th | [model] | [trade-off vs best] | $X/$Y |

### Selection Rules

1. **Free models always get priority for high-frequency agents** — orchestrator, explorer, fixer
2. **Never pay for capabilities you don't use** — don't use a vision model for a non-vision agent
3. **Match reasoning depth to agent need** — don't use V4-Pro for an observer that just summarizes
4. **Consider variant settings** — `high` vs `max` thinking mode changes cost 3-5× for modest quality gain
5. **Prefer newer model versions** — K2.6 > K2.5, M2.7 > M2.5, etc. unless the older version is significantly cheaper and adequate

### Current Selections (2026-06-01)

See `model-selection-analysis.md` for full ranked lists per agent. Summary:

| Agent | Best (budget) | Best (performance) | Key Difference |
|-------|---------------|---------------------|----------------|
| Orchestrator | deepseek-v4-flash-free | deepseek-v4-flash | Paid = no throttling |
| Oracle | qwen3.7-max (max) | qwen3.7-max (max) | Same — V4 Pro price increase makes Q3.7M compelling |
| Council | deepseek-v4-pro (high) | deepseek-v4-pro (high) | Same — now $1.74/$3.48, budget impact |
| Librarian | deepseek-v4-flash-free | deepseek-v4-flash | Paid = no throttling |
| Explorer | deepseek-v4-flash-free | deepseek-v4-flash | Paid = no throttling |
| Designer | mimo-v2.5-free | kimi-k2.6 (medium) | Free vision vs best vision+coding |
| Fixer | deepseek-v4-flash-free (high) | deepseek-v4-flash (high) | V4 Pro too expensive now; accept -11pp Terminal-Bench |
| Observer | deepseek-v4-flash-free | deepseek-v4-flash | Paid = no throttling |

---

## Step 6: Validate with Real Workloads

Benchmarks are proxies. Validate with actual agent tasks:

1. **Run 5-10 representative tasks** per agent with each candidate model
2. **Measure**: Success rate, token usage, latency, cost
3. **Check for failure modes**: Does the model follow the agent's system prompt? Does it respect output format constraints (caveman, JSON, etc.)?
4. **Compare real cost**: `tokens_used × price_per_token` for each task

### Validation Script Template

```bash
# For each agent+model combination, run:
opencode --agent [agent-name] --model [model] --task "[representative task]"

# Record:
# - Success/failure
# - Total tokens (input + output)
# - Wall-clock time
# - Estimated cost
```

---

## Step 7: Update Config

Apply the validated selections to `oh-my-opencode-slim.json`. Two presets are maintained:

### Cost-Effective Preset (~$17-30/month)

Free tier dominant with V4 Pro only for Council. Fixer on V4 Flash Free due to V4 Pro price increase. Designer on MiMo V2.5 Free for free vision.

```json
{
  "preset": "budget",
  "presets": {
    "budget": {
      "orchestrator": {
        "model": "opencode/deepseek-v4-flash-free",
        "variant": "high",
        "skills": ["*", "cavecrew"],
        "mcps": ["*", "!context7"]
      },
      "oracle": {
        "model": "opencode-go/qwen3.7-max",
        "variant": "max",
        "skills": ["simplify"],
        "mcps": []
      },
      "council": {
        "model": "opencode-go/deepseek-v4-pro",
        "variant": "high",
        "skills": [],
        "mcps": []
      },
      "librarian": {
        "model": "opencode/deepseek-v4-flash-free",
        "skills": ["caveman"],
        "mcps": ["websearch", "context7", "grep_app"]
      },
      "explorer": {
        "model": "opencode/deepseek-v4-flash-free",
        "skills": ["caveman"],
        "mcps": []
      },
      "designer": {
        "model": "opencode/mimo-v2.5-free",
        "skills": ["agent-browser"],
        "mcps": []
      },
      "fixer": {
        "model": "opencode/deepseek-v4-flash-free",
        "variant": "high",
        "skills": ["caveman"],
        "mcps": []
      },
      "observer": {
        "model": "opencode/deepseek-v4-flash-free",
        "skills": ["caveman"],
        "mcps": []
      }
    }
  }
}
```

### Performance-Effective Preset (~$36-63/month)

Paid tier for reliability (no throttling). Fixer on V4 Flash due to V4 Pro price increase. Oracle on Q3.7M (now confirmed stronger than V4 Pro).

```json
{
  "preset": "performance",
  "presets": {
    "performance": {
      "orchestrator": {
        "model": "opencode-go/deepseek-v4-flash",
        "variant": "high",
        "skills": ["*", "cavecrew"],
        "mcps": ["*", "!context7"]
      },
      "oracle": {
        "model": "opencode-go/qwen3.7-max",
        "variant": "max",
        "skills": ["simplify"],
        "mcps": []
      },
      "council": {
        "model": "opencode-go/deepseek-v4-pro",
        "variant": "high",
        "skills": [],
        "mcps": []
      },
      "librarian": {
        "model": "opencode-go/deepseek-v4-flash",
        "skills": ["caveman"],
        "mcps": ["websearch", "context7", "grep_app"]
      },
      "explorer": {
        "model": "opencode-go/deepseek-v4-flash",
        "skills": ["caveman"],
        "mcps": []
      },
      "designer": {
        "model": "opencode-go/kimi-k2.6",
        "variant": "medium",
        "skills": ["agent-browser"],
        "mcps": []
      },
      "fixer": {
        "model": "opencode-go/deepseek-v4-flash",
        "variant": "high",
        "skills": ["caveman"],
        "mcps": []
      },
      "observer": {
        "model": "opencode-go/deepseek-v4-flash",
        "skills": ["caveman"],
        "mcps": []
      }
    }
  }
}
```

### Switching Presets

Change the `"preset"` field in `oh-my-opencode-slim.json`:
- `"budget"` — free tier dominant, ~$17-30/month
- `"performance"` — paid tier, ~$36-63/month, better reliability

### Cost Comparison

| Agent | Budget | Performance | Quality Difference |
|-------|--------|-------------|-------------------|
| Orchestrator | $0 (free) | ~$3-5/month | Same model, no throttling |
| Oracle | ~$5-10/month | ~$5-10/month | Same (Q3.7M) |
| Council | ~$12-20/month | ~$12-20/month | Same (V4 Pro, now expensive) |
| Librarian | $0 (free) | ~$2-3/month | Same model, no throttling |
| Explorer | $0 (free) | ~$2-3/month | Same model, no throttling |
| Designer | $0 (MiMo V2.5 Free) | ~$8-15/month | Free vision vs best vision+coding |
| Fixer | $0 (free) | ~$3-5/month | **-11pp Terminal-Bench vs V4 Pro** |
| Observer | $0 (free) | ~$1-2/month | Same model, no throttling |
| **Total** | **~$17-30/month** | **~$36-63/month** | |

---

## Step 8: Document and Schedule Re-evaluation

- Save the analysis as `model-selection-analysis.md` (like this repo does)
- Note the date, model versions, and benchmark sources
- **Re-evaluate quarterly** or when:
  - A new model enters the catalog
  - A model's pricing changes
  - New benchmark results significantly shift rankings
  - You notice quality degradation in production

---

## Quick Reference: Red Flags

| Signal | What It Means | Action |
|--------|--------------|--------|
| Model uses "thinking" mode for simple tasks | Overkill, wasting tokens | Switch to flash/cheaper variant |
| Agent output exceeds expected token count | Model is verbose for the role | Try a model with better IFEval |
| Agent fails tool-calling format | Model doesn't follow instructions well | Switch to higher IFEval/τ²-Bench model |
| Cost spikes without quality improvement | Wrong model for the agent's needs | Re-run this process |
| New model version released | May be better+cheaper | Add to evaluation, compare benchmarks |
| Free tier rate limiting during parallel agent use | Throttling on free tier | Switch to paid variant or performance-effective preset |
| Fixer producing incorrect CLI commands | Terminal-Bench gap matters for your workflow | Upgrade Fixer from V4 Flash to V4 Pro |

---

## Appendix A: Key Model Trade-offs

### DeepSeek V4 Flash vs V4 Pro (the critical decision — UPDATED PRICING)

| Metric | V4 Flash | V4 Pro | Gap |
|--------|----------|--------|-----|
| SWE-bench Verified | 79.0% | 80.6% | +1.6pp |
| Terminal-Bench 2.0 | 56.9% | 67.9% | **+11pp** |
| SWE-bench Pro | 52.6% | 55.4% | +2.8pp |
| LiveCodeBench | 91.6% | 93.5% | +1.9pp |
| GPQA Diamond | 88.1% | 90.1% | +2.0pp |
| Speed (tok/s) | 81-130 | 35-169 | Flash faster at median |
| Cost (input/output) | $0.14/$0.28 | **$1.74/$3.48** | **Flash 12× cheaper** |

**⚠️ Price change**: V4 Pro increased from $0.44/$0.87 to $1.74/$3.48 (4× increase). This makes V4 Pro too expensive for high-frequency agents (Fixer, Orchestrator) and narrows the gap with Qwen 3.7 Max for low-frequency agents (Oracle).

**When to use Flash**: High-frequency agents (orchestrator, explorer, observer, librarian, **now also fixer**) where cost and speed dominate.

**When to use Pro**: Deep-reasoning agents (oracle, council) where the +2pp GPQA and +11pp Terminal-Bench matter — but only if budget allows $1.74/$3.48.

### Why Qwen 3.7 Max for Oracle (strengthened by pricing change)

| Metric | DeepSeek V4 Pro | Qwen 3.7 Max | Delta |
|--------|----------------|---------------|-------|
| GPQA Diamond | 90.1% | 92.4% | **+2.3pp** |
| SWE-bench Verified | 80.6% | 80.4% | -0.2pp |
| Terminal-Bench 2.0 | 67.9% | 69.7% | **+1.8pp** |
| IFBench | 77.0 | 79.1 | **+2.1pp** |
| Speed (tok/s) | 35-169 | 189 | Q3.7M faster |
| Cost (input/output) | $1.74/$3.48 | $2.50/$7.50 | Only 1.4×/2.2× more |
| Context | 1M | 1M | Same |

With V4 Pro's price increase, Q3.7M is now only 1.4× more on input (was 5.7×) and 2.2× on output (was 8.6×). The +2.3pp GPQA, +1.8pp Terminal-Bench, and +2.1pp IFBench advantages make Q3.7M the clear Oracle choice.

### Why Kimi K2.6 for Designer (updated pricing)

| Model | Vision | SWE-bench V | GPQA | Cost |
|-------|--------|-------------|------|------|
| **kimi-k2.6** | Native MoonViT | 80.2% | 90.5% | $0.95/$4.00 |
| kimi-k2.5 | Native MoonViT | 76.8% | 87.6% | $0.60/$3.00 |
| mimo-v2.5 | Native omni | ~78.9% | 84.9% | $0.14/$0.28 |
| mimo-v2.5-free | Native omni | ~78.9% | 84.9% | $0/$0 |
| qwen3.6-plus | Native | 78.8% | 86.0% | $0.50/$3.00 |

K2.6 still has the strongest coding+vision combination. Price increased from $0.60/$2.50 to $0.95/$4.00 but remains the best for Designer. MiMo V2.5 Free is the budget alternative with free vision but weaker coding (LiveCodeBench ~39.6%).

### Why V4 Flash for Fixer (changed from V4 Pro)

V4 Pro at $1.74/$3.48 makes Fixer cost ~$40-60/month — exceeding the entire $60 budget. V4 Flash at $0.14/$0.28 costs ~$3-5/month. The -11pp Terminal-Bench gap (56.9% vs 67.9%) is the trade-off. MiniMax M3 ($0.60/$2.40, Terminal-Bench 66%) is a potential future alternative pending validation of unknown benchmarks.

### Models Considered but Not Selected

| Model | Why Not Selected |
|-------|-----------------|
| **GLM-5** | Best IFEval (92.6%), but $1.00/$3.20 is 7× more expensive than V4 Flash for similar coding quality. Speed too variable (38-212 tok/s). |
| **GLM-5.1** | Best SWE-bench Pro (58.4%), but 86.2% GPQA trails V4 Pro by 4pp. $1.40/$4.40. |
| **MiniMax M2.5** | 80.2% SWE-bench at $0.30/$1.20, but only 197K context and slower (50-100 tok/s). |
| **MiniMax M2.7** | SWE-bench regressed from M2.5 (78% vs 80.2%), same price. |
| **MiniMax M3** | Promising Terminal-Bench 66% and SWE-bench Pro 59%, but SWE-bench V, GPQA, IFEval, and speed are all unknown. **Validate before considering for Fixer.** |
| **MiMo V2.5** | Same price as V4 Flash ($0.14/$0.28) with vision, but LiveCodeBench ~39.6% is too weak for coding-heavy agents. |
| **MiMo V2.5 Pro** | $1.74/$3.48 (same as V4 Pro), weaker coding, weaker reasoning (54% GPQA). No advantage. |
| **Qwen 3.7 Max** (non-Oracle) | Best reasoning (92.4% GPQA), but $2.50/$7.50 is too expensive for high-frequency or parallel agents. Only viable for low-frequency Oracle. |
| **Qwen 3.6 Plus** | $0.50/$3.00, 78.8% SWE-bench, 86.0% GPQA. Weaker than V4 Flash on both counts. |
| **Big Pickle** | Free but context degrades at 50-70K tokens, no reproducible benchmarks. |
| **Nemotron 3 Super** | Free and ultra-fast (~450 tok/s), but 60.5% SWE-bench and very verbose output. |

---

## Appendix B: Benchmark Freshness Checklist

When re-running this process, verify these benchmarks are still current:

- [ ] LiveCodeBench: Check for v7+ (updates monthly)
- [ ] SWE-bench: Check for new Verified/Pro splits
- [ ] LMArena: Check current Elo snapshot (changes weekly)
- [ ] Aider Polyglot: Check for new leaderboard entries
- [ ] Model pricing: Verify on provider website (changes frequently)
- [ ] New model releases: Check provider changelog/blog
- [ ] Artificial Analysis: Verify speed/cost data is current
- [ ] Free tier availability: Confirm opencode/ models still available and free
- [ ] Rate limits: Check if free tier throttling has changed

---

## Appendix C: Models to Watch

| Model | Why | Expected Impact |
|-------|-----|-----------------|
| **MiniMax M3** | Terminal-Bench 66%, native multimodal, $0.60/$2.40 | Could replace V4 Flash as Fixer if SWE-bench V ≥ 79% and GPQA ≥ 85% |
| **DeepSeek V4.1** | Next iteration likely | Could replace V4 Pro/Flash across the board |
| **GLM-5.2** | Post-training improvements | Could challenge for Oracle/Council |
| **Kimi K2.7** | Agent Swarm improvements | Could strengthen Designer role |
| **Qwen 3.8** | Next Max iteration | Could challenge for Oracle if pricing improves |
| **MiMo V2.5 Free** | Free + vision + 1M context | Could replace K2.6 for Designer if coding improves |