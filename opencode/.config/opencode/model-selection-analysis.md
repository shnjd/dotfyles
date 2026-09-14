# Model Selection Analysis

> Date: 2026-06-01 | Methodology: per `model-selection-process.md`
> Budget: $60/month (light usage)
> **Updated**: Pricing corrected to actual provider rates; new models added (MiniMax M3, MiMo V2.5 Free, MiniMax M3 Free)

## Executive Summary

**Critical pricing update**: DeepSeek V4 Pro increased from $0.44/$0.87 to $1.74/$3.48 (4× more expensive), and Kimi K2.6 increased from $0.60/$2.50 to $0.95/$4.00. These changes fundamentally alter the cost/quality trade-offs.

**Key changes from previous analysis**:
1. **Fixer**: Downgraded from V4 Pro to V4 Flash — V4 Pro at $1.74/$3.48 is too expensive for a high-frequency agent (~$40-60/month). Accept -11pp Terminal-Bench gap.
2. **Oracle → Qwen 3.7 Max is now even more compelling** — V4 Pro price increase narrows the gap from 5.7×/8.6× to 1.4×/2.2×.
3. **Budget preset Designer**: Switched from K2.6 ($0.95/$4.00) to MiMo V2.5 Free (free + native vision).
4. **MiniMax M3** added to catalog — promising Terminal-Bench 66% and SWE-bench Pro 59%, but too many unknowns for production use yet.

| Agent | Best Model | Variant | Monthly Cost Est. |
|-------|-----------|---------|-------------------|
| Orchestrator | `opencode-go/deepseek-v4-flash` | high | ~$3-5 |
| Oracle | `opencode-go/qwen3.7-max` | max | ~$5-10 |
| Council | `opencode-go/deepseek-v4-pro` | high | ~$12-20 |
| Librarian | `opencode-go/deepseek-v4-flash` | — | ~$2-3 |
| Explorer | `opencode-go/deepseek-v4-flash` | — | ~$2-3 |
| Designer | `opencode-go/kimi-k2.6` | medium | ~$8-15 |
| Fixer | `opencode-go/deepseek-v4-flash` | high | ~$3-5 |
| Observer | `opencode-go/deepseek-v4-flash` | — | ~$1-2 |
| **Total** | | | **~$36-63/month** |

---

## Model Catalog Summary

### Free Tier (`opencode/`)

| Model | Architecture | Context | SWE-bench V | GPQA | Speed (tok/s) | Vision | Key Trait |
|-------|-------------|---------|-------------|------|---------------|--------|-----------|
| **deepseek-v4-flash-free** | MoE 284B/13B | 1M | 79.0% | 88.1% | 81-130 | No | Best free model |
| **big-pickle** (GLM-4.6) | MoE 355B/32B | 200K† | ~68% | ~81% | Unknown | No | Context degrades >50K |
| **mimo-v2.5-free** | MoE 310B/15B | 1M | ~78.9%‡ | 84.9% | ~93 | Yes (omni) | Free + vision + 1M context |
| **minimax-m3-free** | MoE (unknown) | 1M | Unknown | Unknown | Unknown | Yes (native) | Free + vision + 1M context |
| **nemotron-3-super-free** | Hybrid Mamba+MoE 120B/12B | 1M | 60.5% | 79.2% | ~450 | No | Ultra-fast, weaker accuracy |

†Big Pickle claims 200K context but degrades at 50-70K tokens.
‡MiMo V2.5 SWE-bench figure is from the Pro variant; base V2.5 coding benchmarks are weaker (LiveCodeBench ~39.6%).

### Paid Tier (`opencode-go/`)

| Model | Architecture | Context | SWE-bench V | GPQA | Speed (tok/s) | Vision | Input/Output $/1M |
|-------|-------------|---------|-------------|------|---------------|--------|-------------------|
| **deepseek-v4-flash** | MoE 284B/13B | 1M | 79.0% | 88.1% | 81-130 | No | $0.14/$0.28 |
| **deepseek-v4-pro** | MoE 1.6T/49B | 1M | 80.6% | 90.1% | 35-169 | No | **$1.74/$3.48** |
| **glm-5** | MoE 744B/40B | 200K | 77.8% | 86.0% | 38-212 | No | $1.00/$3.20 |
| **glm-5.1** | MoE ~754B/40B | 200K | 77.8% | 86.2% | 42-186 | No | $1.40/$4.40 |
| **kimi-k2.5** | MoE 1T/32B | 256K | 76.8% | 87.6% | 33-354 | Yes | **$0.60/$3.00** |
| **kimi-k2.6** | MoE 1T/32B | 262K | 80.2% | 90.5% | 33-330 | Yes | **$0.95/$4.00** |
| **mimo-v2.5** | MoE 310B/15B | 1M | ~78.9%‡ | 84.9% | 93 | Yes (omni) | **$0.14/$0.28** |
| **mimo-v2.5-pro** | MoE 1.02T/42B | 1M | 78.9% | ~85% | Unknown | Yes (omni) | **$1.74/$3.48** |
| **minimax-m2.5** | MoE ~230B/10B | 197K | 80.2% | 84.8% | 50-100 | API only | **$0.30/$1.20** |
| **minimax-m2.7** | MoE 229B/10B | 205K | 78.0% | 87.4% | 58.1 | API only | $0.30/$1.20 |
| **minimax-m3** | MoE (unknown) | 1M | Unknown | Unknown | Unknown | Yes (native) | **$0.60/$2.40** |
| **qwen3.6-plus** | Hybrid+MoE | 1M | 78.8% | 86.0% | 52 | Yes | **$0.50/$3.00** |
| **qwen3.7-max** | MoE ~1T | 1M | 80.4% | 92.4% | 189 | No | $2.50/$7.50 |

**Bold** = price changed from previous analysis.

### New Model: MiniMax M3 (Details)

| Attribute | Value |
|-----------|-------|
| Architecture | Sparse MoE with MSA (MiniMax Sparse Attention) |
| Context | 1M tokens (512K guaranteed) |
| Vision | Native multimodal (text, image, video → text) |
| SWE-bench Pro | 59.0% (vendor-reported) |
| Terminal-Bench 2.1 | 66.0% (vendor-reported) |
| MCP-Atlas | 74.2% |
| BrowseComp | 83.5 |
| GPQA Diamond | ❌ Unknown |
| SWE-bench Verified | ❌ Unknown |
| IFEval | ❌ Unknown |
| Speed (tok/s) | ❌ Unknown (claimed 15.6× faster than M2 at 1M context) |
| Pricing | $0.60/$2.40 (promo), cache $0.12 |

**Assessment**: Promising Terminal-Bench (66%, close to V4 Pro's 67.9%) but too many unknowns (no SWE-bench V, no GPQA, no IFEval, no speed data) for production use. Needs validation before consideration for Fixer role.

### Updated Benchmark: Qwen 3.7 Max

| Benchmark | Score | Source |
|-----------|-------|--------|
| IFBench | 79.1 | Official Qwen blog |
| MCP-Atlas | 76.4 | Official Qwen blog |
| Terminal-Bench 2.0 | 69.7 | Official Qwen blog |
| Speed (Artificial Analysis) | 189 tok/s | Artificial Analysis |
| SWE-bench Pro | 60.6 | Official Qwen blog |
| MMLU-Pro | 89.6 | Official Qwen blog |

**Key insight**: Q3.7M now has confirmed Terminal-Bench 69.7% — **better than V4 Pro's 67.9%**. Combined with 92.4% GPQA and 189 tok/s speed, it's the strongest Oracle candidate by a wider margin than previously thought.

---

## Weighted Scoring Methodology

Per the model-selection-process.md, each agent type has specific weight templates:

| Agent Type | Coding | Reasoning | Speed | Cost | Special |
|-----------|--------|-----------|-------|------|---------|
| **Orchestrator** | 20% | 30% | 25% | 25% | 0% |
| **Deep Thinker** (Oracle/Council) | 25% | 40% | 10% | 25% | 0% |
| **Search/Retrieval** (Librarian/Explorer) | 15% | 15% | 30% | 40% | 0% |
| **Implementation** (Fixer) | 40% | 15% | 25% | 20% | 0% |
| **Design** (Designer) | 30% | 10% | 15% | 15% | 30% (vision) |
| **Monitor** (Observer) | 10% | 10% | 25% | 55% | 0% |

### Budget-Adjusted Weights ($60/month, light usage)

With a $60/month budget and light daily usage, cost is no longer the primary constraint for most agents. We adjust weights by reducing cost importance and redistributing to quality dimensions:

| Agent Type | Coding | Reasoning | Speed | Cost | Special |
|-----------|--------|-----------|-------|------|---------|
| **Orchestrator** | 25% | 35% | 30% | 10% | 0% |
| **Deep Thinker** (Oracle/Council) | 25% | 50% | 10% | 15% | 0% |
| **Search/Retrieval** (Librarian/Explorer) | 20% | 20% | 35% | 25% | 0% |
| **Implementation** (Fixer) | 45% | 20% | 25% | 10% | 0% |
| **Design** (Designer) | 30% | 10% | 15% | 15% | 30% (vision) |
| **Monitor** (Observer) | 15% | 15% | 35% | 35% | 0% |

### Selection Rules Applied

1. ✅ **Paid models preferred for reliability** — no throttling during parallel agent runs
2. ✅ **Never pay for capabilities you don't use** — no vision models for non-vision agents
3. ✅ **Match reasoning depth to agent need** — Qwen 3.7 Max for Oracle (deep reasoning), V4 Flash for Explorer (shallow)
4. ✅ **Prefer newer model versions** — K2.6 > K2.5, M2.7 > M2.5
5. ✅ **Budget allows premium models for low-frequency agents** — Oracle can use Qwen 3.7 Max
6. ✅ **Price changes force re-evaluation** — V4 Pro at $1.74/$3.48 is no longer viable for high-frequency agents

---

## Agent-by-Agent Selection ($60/month Budget)

### 1. Orchestrator

**Profile**: Very High frequency · Medium reasoning · Critical speed · No special capabilities
**Budget-adjusted weights**: Coding 25% · Reasoning 35% · Speed 30% · Cost 10%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-flash` | Fast (81-130 tok/s), strong reasoning (88.1% GPQA), 1M context, excellent IFEval (86.1%), no throttling. Best speed/quality/cost balance. | $0.14/$0.28 |
| 2nd | `opencode/deepseek-v4-flash-free` | Identical capability, free. Risk: throttling during parallel agent calls. | $0/$0 |
| 3rd | `opencode-go/mimo-v2.5` | Same price as V4 Flash ($0.14/$0.28), adds vision (unused), 1M context. But weaker coding (~78.9% SWE vs 79.0%) and LiveCodeBench ~39.6%. No advantage for orchestration. | $0.14/$0.28 |
| 4th | `opencode-go/glm-5` | Best IFEval (92.6%), lowest hallucination. But 7× more expensive and variable speed (38-212 tok/s). | $1.00/$3.20 |

**Why DeepSeek V4 Flash wins**: Unchanged. Speed is critical (30% weight), and V4 Flash delivers consistent 81-130 tok/s at $0.14/$0.28. MiMo V2.5 at the same price adds unused vision and weaker coding.

---

### 2. Oracle

**Profile**: Low frequency · Deep reasoning · Tolerable speed · No special capabilities
**Budget-adjusted weights**: Coding 25% · Reasoning 50% · Speed 10% · Cost 15%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/qwen3.7-max` | **Best reasoning** (92.4% GPQA, +2.3pp over V4 Pro). Confirmed Terminal-Bench 69.7% (better than V4 Pro's 67.9%). 189 tok/s speed. Now only 1.4×/2.2× more expensive than V4 Pro (was 5.7×/8.6×). Low frequency makes cost manageable. | $2.50/$7.50 |
| 2nd | `opencode-go/deepseek-v4-pro` | Previous best. 90.1% GPQA, 80.6% SWE-bench, 67.9% Terminal-Bench. Now $1.74/$3.48 — price gap vs Q3.7M narrowed dramatically. | $1.74/$3.48 |
| 3rd | `opencode-go/kimi-k2.6` | 90.5% GPQA, vision (unused). $0.95/$4.00 is moderate but output cost is high. | $0.95/$4.00 |
| 4th | `opencode-go/glm-5.1` | Best SWE-bench Pro (58.4%), but 86.2% GPQA trails V4 Pro by 4pp. | $1.40/$4.40 |

**Why Qwen 3.7 Max wins even more decisively**: V4 Pro's price increase from $0.44/$0.87 to $1.74/$3.48 eliminated its cost advantage. Q3.7M is now only 1.4× more on input and 2.2× on output — while delivering +2.3pp GPQA, +0.2pp SWE-bench V, and +1.8pp Terminal-Bench. The confirmed 189 tok/s speed and IFBench 79.1 address previous unknowns.

---

### 3. Council

**Profile**: Low-Med frequency · Deep reasoning · Tolerable speed · Parallel (3-5 instances)
**Budget-adjusted weights**: Coding 25% · Reasoning 50% · Speed 10% · Cost 15%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-pro` | Best reasoning/cost ratio for parallel use. 90.1% GPQA. Now $1.74/$3.48 — expensive for 3-5 parallel instances (~$12-20/session), but still the best option. | $1.74/$3.48 |
| 2nd | `opencode-go/kimi-k2.6` | 90.5% GPQA (+0.4pp), vision (unused). $0.95/$4.00 — lower input but higher output cost. Similar total cost with parallelism. | $0.95/$4.00 |
| 3rd | `opencode-go/qwen3.7-max` | Best reasoning (92.4% GPQA) but 3-5 parallel instances at $2.50/$7.50 = ~$15-40/session. Too expensive even at $60 budget. | $2.50/$7.50 |
| 4th | `opencode-go/deepseek-v4-flash` | 88.1% GPQA is 2pp behind V4 Pro — noticeable gap for deep reasoning. But 12× cheaper at $0.14/$0.28. | $0.14/$0.28 |

**Why DeepSeek V4 Pro still wins (barely)**: Council needs deep reasoning (50% weight). V4 Pro's 90.1% GPQA is the minimum acceptable for consensus-building. K2.6 is a viable alternative at similar total cost. V4 Flash's 2pp GPQA gap is too large for deep reasoning tasks.

**⚠️ Budget impact**: Council now costs ~$12-20/month (was ~$3-5). This is the biggest cost increase in the new pricing. Consider switching to K2.6 if output token usage is lower than input.

---

### 4. Librarian

**Profile**: High frequency · Medium reasoning · Important speed · Web search capability
**Budget-adjusted weights**: Coding 20% · Reasoning 20% · Speed 35% · Cost 25%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-flash` | Fast (81-130 tok/s), 1M context for processing search results, strong tool use (MCPAtlas 73.6%), good IFEval (86.1%). | $0.14/$0.28 |
| 2nd | `opencode/deepseek-v4-flash-free` | Identical capability, free. Risk: throttling during rapid search queries. | $0/$0 |
| 3rd | `opencode-go/minimax-m2.5` | Best τ²-Bench (95.3%) for tool use, 80.2% SWE-bench. But slower (50-100 tok/s) and only 197K context. Now $0.30/$1.20 (was $0.15/$1.15). | $0.30/$1.20 |
| 4th | `opencode/nemotron-3-super-free` | Ultra-fast (~450 tok/s), free. But 60.5% SWE-bench and very verbose output. | $0/$0 |

**Why DeepSeek V4 Flash wins**: Unchanged. Speed + 1M context + low cost is unbeatable for search.

---

### 5. Explorer

**Profile**: Very High frequency · Shallow reasoning · Critical speed · Parallel (2-4 instances)
**Budget-adjusted weights**: Coding 20% · Reasoning 20% · Speed 35% · Cost 25%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-flash` | Fast, 1M context, adequate reasoning for grep/glob/AST tasks. Paid tier ensures no throttling during 2-4 parallel instances. | $0.14/$0.28 |
| 2nd | `opencode/deepseek-v4-flash-free` | Identical capability, free. Risk: throttling when 2-4 instances run simultaneously. | $0/$0 |
| 3rd | `opencode/nemotron-3-super-free` | Ultra-fast (~450 tok/s), free. But 60.5% SWE-bench is weak even for shallow search. | $0/$0 |
| 4th | `opencode-go/mimo-v2.5` | Same price as V4 Flash ($0.14/$0.28), 1M context, vision (unused). Weaker coding (LiveCodeBench ~39.6%). | $0.14/$0.28 |

**Why DeepSeek V4 Flash wins**: Unchanged. Speed + 1M context + lowest paid cost.

---

### 6. Designer

**Profile**: Medium frequency · Medium reasoning · Important speed · **Vision required**
**Budget-adjusted weights**: Coding 30% · Reasoning 10% · Speed 15% · Cost 15% · Vision 30%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/kimi-k2.6` | Native MoonViT vision, strongest coding among vision models (80.2% SWE, 89.6% LCB), 90.5% GPQA, 262K context. Now $0.95/$4.00 — more expensive but still best vision+coding. | $0.95/$4.00 |
| 2nd | `opencode/mimo-v2.5-free` | **New option**: Free + native omnimodal vision + 1M context. Weaker coding (LiveCodeBench ~39.6%, SWE-bench ~78.9%). Best free vision option. | $0/$0 |
| 3rd | `opencode-go/kimi-k2.5` | Same MoonViT vision, $0.60/$3.00, but 3.4pp behind on SWE-bench (76.8%) and 2.9pp behind on GPQA (87.6%). | $0.60/$3.00 |
| 4th | `opencode-go/mimo-v2.5` | Native omnimodal, 1M context, $0.14/$0.28 (same as V4 Flash!). Weaker coding than K2.6. Budget-friendly paid vision option. | $0.14/$0.28 |
| 5th | `opencode-go/qwen3.6-plus` | Native vision, $0.50/$3.00, 78.8% SWE, 1M context. Weaker coding than K2.6 by 1.4pp. | $0.50/$3.00 |

**Why Kimi K2.6 still wins**: Despite the price increase ($0.95/$4.00 vs old $0.60/$2.50), K2.6 has the strongest vision+coding combination. No vision-capable model comes close on coding benchmarks.

**Budget alternative**: `opencode/mimo-v2.5-free` — free with native omnimodal vision and 1M context. Weaker coding (LiveCodeBench ~39.6%) but adequate for UI/UX review where vision matters more than competitive coding.

---

### 7. Fixer — 🔴 MAJOR CHANGE

**Profile**: Very High frequency · Medium reasoning · Critical speed · Parallel (2-4 instances)
**Budget-adjusted weights**: Coding 45% · Reasoning 20% · Speed 25% · Cost 10%

**Previous selection**: `opencode-go/deepseek-v4-pro` (high) at $0.44/$0.87
**Price change**: V4 Pro now $1.74/$3.48 — 4× more expensive. Estimated Fixer cost: ~$40-60/month. **No longer viable within $60 budget.**

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-flash` | 79.0% SWE-bench, 91.6% LCB, fast (81-130 tok/s), cheap ($0.14/$0.28). Terminal-Bench 56.9% is 11pp behind V4 Pro — the key trade-off. | $0.14/$0.28 |
| 2nd | `opencode-go/minimax-m3` | Terminal-Bench 66% (close to V4 Pro's 67.9%), SWE-bench Pro 59%. But SWE-bench V, GPQA, IFEval, and speed are **unknown**. $0.60/$2.40 is moderate. **Needs validation.** | $0.60/$2.40 |
| 3rd | `opencode-go/deepseek-v4-pro` | Best Terminal-Bench (67.9%), 80.6% SWE-bench. But at $1.74/$3.48, Fixer alone costs ~$40-60/month. **Luxury option** — only if budget allows $100+/month. | $1.74/$3.48 |
| 4th | `opencode-go/minimax-m2.5` | 80.2% SWE-bench (tied with K2.6), $0.30/$1.20. But unknown Terminal-Bench, slower (50-100 tok/s), only 197K context. | $0.30/$1.20 |

**Why DeepSeek V4 Flash wins now**: The 4× price increase for V4 Pro makes it unaffordable for a high-frequency, parallel agent. V4 Flash at $0.14/$0.28 is 12× cheaper, and its 79.0% SWE-bench is still strong. The -11pp Terminal-Bench gap (56.9% vs 67.9%) is the real cost — Fixer will be less reliable at CLI commands.

**MiniMax M3 as future Fixer**: If M3's SWE-bench V and GPQA scores are confirmed strong (≥79% and ≥88%), it could replace V4 Flash as the best mid-range Fixer at $0.60/$2.40 with Terminal-Bench 66%. **Validate before switching.**

**Alternative for budget-constrained periods**: `opencode/deepseek-v4-flash-free` (variant: high) — free, same capability, throttling risk.

---

### 8. Observer

**Profile**: Medium frequency · Shallow reasoning · Important speed · No special capabilities
**Budget-adjusted weights**: Coding 15% · Reasoning 15% · Speed 35% · Cost 35%

| Rank | Model | Rationale | Cost |
|------|-------|-----------|------|
| **Best** | `opencode-go/deepseek-v4-flash` | Fast, cheap, adequate reasoning for monitoring/summarization, good IFEval (86.1%). | $0.14/$0.28 |
| 2nd | `opencode/deepseek-v4-flash-free` | Identical capability, free. Acceptable for observer since it's not parallel and less latency-sensitive. | $0/$0 |
| 3rd | `opencode/nemotron-3-super-free` | Ultra-fast (~450 tok/s), free. But very verbose output wastes tokens. | $0/$0 |
| 4th | `opencode-go/minimax-m2.5` | Best τ²-Bench (95.3%) for structured output, $0.30/$1.20. Overkill for monitoring. | $0.30/$1.20 |

**Why DeepSeek V4 Flash wins**: Unchanged. Cost efficiency + speed for shallow monitoring tasks.

---

## Final Configuration ($60/month Budget)

### Performance Preset (~$36-63/month)

Best quality within $60/month. Uses paid models for reliability (no throttling). Fixer downgraded from V4 Pro to V4 Flash due to pricing.

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

### Budget Preset (~$17-30/month)

Uses free models for high-frequency agents. Designer uses MiMo V2.5 Free for free vision. Risk: free tier throttling during parallel runs.

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

---

## Cost Analysis

### Performance Preset (~$36-63/month)

| Agent | Model | Input $/1M | Output $/1M | Est. Monthly Cost |
|-------|-------|-----------|-------------|-------------------|
| Orchestrator | deepseek-v4-flash | $0.14 | $0.28 | ~$3-5 |
| Oracle | qwen3.7-max | $2.50 | $7.50 | ~$5-10 |
| Council (×3-5) | deepseek-v4-pro | $1.74 | $3.48 | ~$12-20 |
| Librarian | deepseek-v4-flash | $0.14 | $0.28 | ~$2-3 |
| Explorer | deepseek-v4-flash | $0.14 | $0.28 | ~$2-3 |
| Designer | kimi-k2.6 | $0.95 | $4.00 | ~$8-15 |
| Fixer | deepseek-v4-flash | $0.14 | $0.28 | ~$3-5 |
| Observer | deepseek-v4-flash | $0.14 | $0.28 | ~$1-2 |
| **Total** | | | | **~$36-63** |

### Budget Preset (~$17-30/month)

| Agent | Model | Input $/1M | Output $/1M | Est. Monthly Cost |
|-------|-------|-----------|-------------|-------------------|
| Orchestrator | deepseek-v4-flash-free | $0 | $0 | $0 |
| Oracle | qwen3.7-max | $2.50 | $7.50 | ~$5-10 |
| Council (×3-5) | deepseek-v4-pro | $1.74 | $3.48 | ~$12-20 |
| Librarian | deepseek-v4-flash-free | $0 | $0 | $0 |
| Explorer | deepseek-v4-flash-free | $0 | $0 | $0 |
| Designer | mimo-v2.5-free | $0 | $0 | $0 |
| Fixer | deepseek-v4-flash-free | $0 | $0 | $0 |
| Observer | deepseek-v4-flash-free | $0 | $0 | $0 |
| **Total** | | | | **~$17-30** |

### Comparison with Previous Presets

| Preset | Oracle | Fixer | Designer | Council | Est. Monthly |
|--------|--------|-------|----------|---------|-------------|
| Cost-effective (~$15) | V4 Pro (max) | V4 Flash Free | K2.6 | V4 Pro (high) | ~$10-28 |
| Performance (~$35) | V4 Pro (max) | V4 Pro (high) | K2.6 | V4 Pro (high) | ~$31-53 |
| **Performance (new pricing)** | **Q3.7 Max** | **V4 Flash** | **K2.6** | **V4 Pro** | **~$36-63** |
| **Budget (new pricing)** | **Q3.7 Max** | **V4 Flash Free** | **MiMo V2.5 Free** | **V4 Pro** | **~$17-30** |

### Key Price Impact Summary

| Change | Old Cost | New Cost | Impact |
|--------|----------|----------|--------|
| V4 Pro (Fixer) | ~$10-15/mo | ~$40-60/mo | 🔴 **4× increase, no longer viable** |
| V4 Pro (Council) | ~$3-5/mo | ~$12-20/mo | 🔴 **3-4× increase, still best option** |
| K2.6 (Designer) | ~$5-10/mo | ~$8-15/mo | 🟡 **~60% increase, still best vision** |
| Q3.7 Max (Oracle) | ~$5-10/mo | ~$5-10/mo | ✅ Unchanged, now more compelling vs V4 Pro |

---

## Key Trade-offs and Risks

### Fixer Downgrade Risk (V4 Pro → V4 Flash)

| Metric | V4 Flash | V4 Pro | Gap |
|--------|----------|--------|-----|
| SWE-bench Verified | 79.0% | 80.6% | -1.6pp |
| Terminal-Bench 2.0 | 56.9% | 67.9% | **-11pp** |
| SWE-bench Pro | 52.6% | 55.4% | -2.8pp |
| LiveCodeBench | 91.6% | 93.5% | -1.9pp |
| Cost (in/out) | $0.14/$0.28 | $1.74/$3.48 | 12× cheaper |

**Mitigation**: Monitor Fixer CLI command accuracy. If Terminal-Bench gap causes frequent errors, consider MiniMax M3 ($0.60/$2.40, Terminal-Bench 66%) after validation.

### Qwen 3.7 Max Updated Assessment (Oracle)

| Risk | Previous Status | Updated Status |
|------|----------------|----------------|
| Unknown IFEval | ❌ Unknown | ✅ IFBench 79.1 (beats V4 Pro's 77.0) |
| Unknown speed | ❌ Unknown | ✅ 189 tok/s (faster than V4 Pro median) |
| Unknown tool use | ❌ Unknown | ✅ MCP-Atlas 76.4, MCP-Mark 60.8 |
| Unknown Terminal-Bench | ❌ Unknown | ✅ 69.7% (better than V4 Pro's 67.9%) |
| High output cost | $7.50/1M | $7.50/1M (unchanged, but V4 Pro now $3.48) |

**Assessment**: Q3.7M risks have been substantially reduced. Confirmed benchmarks show it matches or exceeds V4 Pro across all dimensions. The only remaining risk is production stability (less community testing).

### Council Cost Pressure

V4 Pro at $1.74/$3.48 makes Council the most expensive agent per session (~$12-20/month with 3-5 parallel instances). Consider:
- **Budget alternative**: Switch Council to `opencode-go/kimi-k2.6` (medium) — 90.5% GPQA at $0.95/$4.00. Similar total cost but different cost structure (lower input, higher output).
- **Quality alternative**: Keep V4 Pro — 90.1% GPQA is the minimum for deep reasoning consensus.

### Models Considered but Not Selected

| Model | Why Not Selected |
|-------|-----------------|
| **GLM-5** | Best IFEval (92.6%), but $1.00/$3.20 is 7× V4 Flash for similar coding. Speed too variable (38-212 tok/s). |
| **GLM-5.1** | Best SWE-bench Pro (58.4%), but 86.2% GPQA trails V4 Pro by 4pp. $1.40/$4.40. |
| **MiniMax M2.5** | 80.2% SWE-bench at $0.30/$1.20, but only 197K context and slower (50-100 tok/s). |
| **MiniMax M2.7** | SWE-bench regressed from M2.5 (78% vs 80.2%), same price. |
| **MiniMax M3** | Promising Terminal-Bench 66%, but SWE-bench V, GPQA, IFEval, and speed are all unknown. **Validate before considering for Fixer.** |
| **MiMo V2.5** | Same price as V4 Flash ($0.14/$0.28) with vision, but LiveCodeBench ~39.6% is too weak for coding-heavy agents. |
| **MiMo V2.5 Pro** | $1.74/$3.48 (same as V4 Pro), weaker coding, weaker reasoning (54% GPQA). No advantage. |
| **Qwen 3.6 Plus** | $0.50/$3.00, 78.8% SWE-bench, 86.0% GPQA. Weaker than V4 Flash on both counts. |
| **Qwen 3.7 Max** (non-Oracle) | $2.50/$7.50 too expensive for high-frequency or parallel agents. |
| **Big Pickle** | Free but context degrades at 50-70K tokens, no reproducible benchmarks. |
| **Nemotron 3 Super** | Free and ultra-fast (~450 tok/s), but 60.5% SWE-bench and very verbose output. |

---

## Validation Checklist

Before deploying, validate with 5-10 representative tasks per agent:

- [ ] **Orchestrator**: Test delegation decisions, multi-agent coordination, long context handling
- [ ] **Oracle**: Test deep reasoning on architecture decisions — Q3.7M now has confirmed benchmarks
- [ ] **Council**: Test 3-5 parallel instances for consensus building — **monitor cost closely**
- [ ] **Librarian**: Test web search, documentation lookup, tool calling
- [ ] **Explorer**: Test codebase search speed, pattern matching accuracy
- [ ] **Designer**: Test vision-based UI review with K2.6 — **also test MiMo V2.5 Free as budget alternative**
- [ ] **Fixer**: Test code editing accuracy, CLI commands — **critical: validate V4 Flash Terminal-Bench gap impact**
- [ ] **Observer**: Test summarization, monitoring output format compliance

### Key Metrics to Track

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Task success rate | >90% | <80% |
| Token usage per task | Within 2× of baseline | >3× baseline |
| Latency (p50) | <30s for search agents | >60s |
| Cost per session | <$2 | >$5 |
| Oracle cost per month | <$12 | >$15 |
| Council cost per month | <$25 | >$30 |
| Fixer CLI command success | >85% | <75% |
| Total monthly cost | <$60 | >$60 |

### MiniMax M3 Validation Priority

If considering M3 for Fixer role:

1. **SWE-bench Verified**: Must be ≥79% to match V4 Flash
2. **GPQA Diamond**: Must be ≥85% for adequate reasoning
3. **IFEval**: Must be ≥80% for instruction following
4. **Speed**: Must be ≥50 tok/s for Fixer's speed needs
5. **Terminal-Bench 2.0**: Already 66% (close to V4 Pro's 67.9%)

---

## Re-evaluation Triggers

Re-run this analysis when:
- [ ] MiniMax M3 benchmarks (SWE-bench V, GPQA, IFEval, speed) become available
- [ ] A model's pricing changes (especially V4 Pro, K2.6)
- [ ] New benchmark results significantly shift rankings
- [ ] Quality degradation is noticed in production
- [ ] Fixer CLI command accuracy drops below 85% (consider M3 or V4 Pro upgrade)
- [ ] Quarterly review (next: September 2026)

### Models to Watch

| Model | Why | Expected Impact |
|-------|-----|-----------------|
| **MiniMax M3** | Terminal-Bench 66%, native multimodal, $0.60/$2.40 | Could replace V4 Flash as Fixer if SWE-bench V ≥ 79% |
| **DeepSeek V4.1** | Next iteration likely | Could replace V4 Pro/Flash across the board |
| **GLM-5.2** | Post-training improvements | Could challenge for Oracle/Council |
| **Kimi K2.7** | Agent Swarm improvements | Could strengthen Designer role |
| **Qwen 3.8** | Next Max iteration | Could challenge for Oracle if pricing improves |
| **MiMo V2.5 Free** | Free + vision + 1M context | Could replace K2.6 for Designer if coding improves |