# Ollama Models Quick Reference

Pre-configured models optimized for JavaScript/Node.js development on Mac M5 32GB RAM.

## Installation Commands

### Recommended Starting Point

```bash
# Best all-around model for JavaScript/Node.js
ollama pull qwen2.5-coder:32b-instruct-q4_K_M

# Fast and excellent for web development
ollama pull yi-coder:9b-chat-q4_K_M

# Great for quick tasks
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
```

## Model Comparison

| Model | Size | Speed | Memory | Best Use Case |
|-------|------|-------|--------|---------------|
| **qwen2.5-coder:32b-q4_K_M** | 18GB | 40-60 t/s | 20GB | Complex code, refactoring, architecture |
| **yi-coder:9b-q4_K_M** | 6GB | 80-100 t/s | 8GB | Web dev, React, Node.js, fast iterations |
| **deepseek-coder-v2:16b-q4_K_M** | 10GB | 60-80 t/s | 12GB | General coding, debugging |
| **qwen2.5-coder:7b-q4_K_M** | 5GB | 100+ t/s | 6GB | Quick edits, comments, simple tasks |
| **qwen2.5-coder:3b-q4_K_M** | 2.5GB | 150+ t/s | 3GB | Autocompletion, inline suggestions |

## Pull All Recommended Models

```bash
# Tier 1: Best for JavaScript/Node.js
ollama pull qwen2.5-coder:32b-instruct-q4_K_M
ollama pull qwen2.5-coder:32b-instruct-q5_K_M
ollama pull yi-coder:9b-chat-q4_K_M
ollama pull yi-coder:9b-chat-q5_K_M
ollama pull deepseek-coder-v2:16b-lite-instruct-q4_K_M
ollama pull deepseek-coder-v2:16b-lite-instruct-q5_K_M

# Tier 2: Powerful alternatives
ollama pull qwen3-coder:30b-a3b-instruct-q4_K_M
ollama pull codeqwen:7b-code-v1.5-q4_K_M
ollama pull qwen2.5-coder:7b-instruct-q4_K_M

# Tier 3: Lightweight options
ollama pull qwen2.5-coder:3b-instruct-q4_K_M
ollama pull qwen2.5:14b-instruct-q4_K_M
ollama pull llama3.2:3b-instruct-q4_K_M
```

## Switching Models in Neovim

```vim
:PrtModel
```

This will show a list of all installed models. Select one to switch.

## Model Details

### Qwen2.5-Coder 32B (Recommended Default)
- **Training**: 5.5 trillion tokens of code
- **Languages**: 92+ including JavaScript, TypeScript, Node.js
- **Context**: 128K tokens
- **Strengths**: Complex reasoning, large codebases, refactoring
- **Use when**: Working on complex features, architectural decisions

### Yi-Coder 9B (Fast Web Dev)
- **Training**: Optimized for web development
- **Languages**: JavaScript, TypeScript, Node.js, React, HTML, CSS, SQL
- **Context**: 128K tokens
- **Strengths**: Fast responses, web-specific knowledge
- **Use when**: Building web apps, React components, Express routes

### DeepSeek-Coder V2 16B (Balanced)
- **Training**: 2+ trillion tokens
- **Architecture**: Mixture-of-Experts (MoE) - faster than dense models
- **Performance**: Rivals GPT-4 Turbo
- **Strengths**: Debugging, code review, general coding
- **Use when**: Need balance of speed and quality

### Qwen2.5-Coder 7B (Quick Tasks)
- **Training**: Same as 32B but smaller
- **Speed**: 100+ tokens/second
- **Strengths**: Fast, good for simple tasks
- **Use when**: Adding comments, simple functions, quick edits

### Qwen2.5-Coder 3B (Ultra-Fast)
- **Speed**: 150+ tokens/second
- **Memory**: Only 2-3GB
- **Strengths**: Instant responses
- **Use when**: Autocompletion, inline suggestions

## Performance Tips

1. **Preload your main model** to keep it in memory:
   ```bash
   ollama run qwen2.5-coder:32b-instruct-q4_K_M ""
   ```

2. **Use smaller models for quick tasks** - Switch to 7B or 3B for comments and simple edits

3. **Use larger models for complex work** - Switch to 32B for refactoring and architecture

4. **Monitor memory** with `ollama ps` to see what's loaded

## Quantization Guide

- **Q4_K_M**: Best balance (recommended)
- **Q5_K_M**: Slightly better quality, 20% larger
- **Q8_0**: Near-original quality, 2x larger

For your 32GB Mac M5, Q4_K_M is the sweet spot.

## See Also

- [OLLAMA_SETUP.md](OLLAMA_SETUP.md) - Complete setup guide
- [Parrot.nvim Commands](https://github.com/frankroeder/parrot.nvim#commands)
