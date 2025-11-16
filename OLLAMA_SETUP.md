# Ollama + Parrot.nvim Setup Guide

This Neovim configuration includes **Parrot.nvim** integrated with **Ollama** for local AI-powered coding assistance. All models run locally on your Mac M5 with 32GB RAM—no cloud APIs, no subscription fees, complete privacy.

## Quick Start

### 1. Install Ollama

```bash
# Install Ollama on macOS
brew install ollama

# Start Ollama service
ollama serve
```

### 2. Pull Recommended Models

Based on extensive research for JavaScript/Node.js development on Mac M5 32GB, here are the recommended models:

#### Tier 1: Best for JavaScript/Node.js (Start Here)

```bash
# Qwen2.5-Coder 32B - Top recommendation (Q4 quantization)
ollama pull qwen2.5-coder:32b-instruct-q4_K_M

# Yi-Coder 9B - Fast and excellent for web development
ollama pull yi-coder:9b-chat-q4_K_M

# DeepSeek-Coder V2 16B - Great all-rounder with MoE
ollama pull deepseek-coder-v2:16b-lite-instruct-q4_K_M
```

#### Tier 2: Powerful Alternatives

```bash
# Qwen3-Coder 30B - Latest MoE model (if available)
ollama pull qwen3-coder:30b-a3b-instruct-q4_K_M

# Qwen2.5-Coder 7B - Lightweight but capable
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
```

#### Tier 3: Ultra-Fast Options

```bash
# Qwen2.5-Coder 3B - For quick completions
ollama pull qwen2.5-coder:3b-instruct-q4_K_M
```

### 3. Verify Installation

```bash
# List installed models
ollama list

# Test a model
ollama run qwen2.5-coder:32b-instruct-q4_K_M "Write a hello world in JavaScript"
```

## Model Selection Guide

### For Your Mac M5 32GB Setup

Your hardware can comfortably run models up to 32B parameters with Q4/Q5 quantization. Here's what to expect:

| Model | Size | Speed (tokens/sec) | Memory Usage | Best For |
|-------|------|-------------------|--------------|----------|
| **qwen2.5-coder:32b-q4** | ~18GB | 40-60 | ~20GB | Complex code, refactoring |
| **yi-coder:9b-q4** | ~6GB | 80-100 | ~8GB | Web dev, fast iterations |
| **deepseek-coder-v2:16b-q4** | ~10GB | 60-80 | ~12GB | General coding, debugging |
| **qwen2.5-coder:7b-q4** | ~5GB | 100+ | ~6GB | Quick edits, comments |
| **qwen2.5-coder:3b-q4** | ~2.5GB | 150+ | ~3GB | Autocompletion |

### Quantization Explained

- **Q4_K_M**: 4-bit quantization, ~50% size reduction, excellent quality
- **Q5_K_M**: 5-bit quantization, slightly larger, better quality
- **Q8_0**: 8-bit quantization, near-original quality, much larger

**Recommendation**: Start with Q4_K_M. It's the sweet spot for quality and performance on your hardware.

## Using Parrot.nvim

### Basic Commands

#### Chat Commands
- `:PrtChatNew` - Start a new chat session
- `:PrtChatToggle` - Toggle chat window
- `:PrtChatDelete` - Delete current chat
- `<C-g><C-g>` - Send message in chat (Normal/Insert/Visual mode)
- `<C-g>d` - Delete current chat
- `<C-g>s` - Stop generation
- `<C-g>c` - New chat

#### Code Commands
- `:PrtComplete` - Complete code based on context
- `:PrtExplain` - Explain selected code
- `:PrtFixBugs` - Fix bugs in selected code
- `:PrtOptimize` - Optimize selected code
- `:PrtUnitTests` - Generate unit tests
- `:PrtAddComments` - Add JSDoc comments

#### Model Management
- `:PrtProvider` - Switch provider (Ollama)
- `:PrtModel` - Switch model
- `:PrtInfo` - Show current model info

### Workflow Examples

#### 1. Code Completion
```javascript
// Type a comment describing what you want
// TODO: Create an async function to fetch user data from API

// Select the comment line, then run:
:PrtComplete
```

#### 2. Debug and Fix
```javascript
// Select buggy code in visual mode, then:
:PrtFixBugs
```

#### 3. Add Documentation
```javascript
// Select a function, then:
:PrtAddComments
```

#### 4. Chat About Code
```
:PrtChatNew

# In the chat buffer, ask questions like:
How can I optimize this Express.js route for better performance?
What's the best way to handle errors in async/await?
Explain the difference between map() and forEach()
```

## Model Recommendations by Task

### Complex Code Generation & Refactoring
**Use**: `qwen2.5-coder:32b-instruct-q4_K_M`
- Handles large context windows
- Excellent at understanding complex logic
- Best for architectural decisions

### Fast Iterations & General Coding
**Use**: `deepseek-coder-v2:16b-lite-instruct-q4_K_M` or `yi-coder:9b-chat-q4_K_M`
- Quick responses
- Good balance of quality and speed
- Great for day-to-day coding

### Quick Edits & Comments
**Use**: `qwen2.5-coder:7b-instruct-q4_K_M`
- Very fast
- Good for simple tasks
- Low memory footprint

### Inline Autocompletion
**Use**: `qwen2.5-coder:3b-instruct-q4_K_M`
- Ultra-fast responses
- Minimal memory usage
- Perfect for quick suggestions

## Performance Tips

### 1. Keep Ollama Running
```bash
# Start Ollama as a service (runs in background)
brew services start ollama
```

### 2. Preload Models
```bash
# Preload a model to keep it in memory
ollama run qwen2.5-coder:32b-instruct-q4_K_M ""
```

### 3. Monitor Resources
```bash
# Check Ollama status
ollama ps

# Check memory usage
ollama show qwen2.5-coder:32b-instruct-q4_K_M
```

### 4. Adjust Context Window
Edit `lua/plugins/parrot.lua` to adjust `num_ctx`:
- **8192**: Fast, good for most tasks
- **16384**: Balanced, handles larger files
- **32768**: Maximum context, slower but understands entire codebases

## Troubleshooting

### Ollama Not Running
```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Start Ollama
ollama serve
```

### Model Not Found
```bash
# List installed models
ollama list

# Pull missing model
ollama pull qwen2.5-coder:32b-instruct-q4_K_M
```

### Slow Performance
1. Use smaller models (7B or 9B)
2. Use Q4 quantization instead of Q5
3. Reduce `num_ctx` in configuration
4. Close other memory-intensive applications

### Out of Memory
1. Use smaller models
2. Reduce `num_ctx` to 8192 or 4096
3. Use Q4 quantization
4. Close other applications

## Advanced Configuration

### Custom System Prompts

Edit `lua/plugins/parrot.lua` to add custom hooks:

```lua
hooks = {
  MyCustomHook = function(parrot, params)
    local template = [[
    Your custom prompt here with {{selection}}
    ]]
    local model = parrot.get_model('command')
    parrot.Prompt(params, parrot.ui.Target.rewrite, model, nil, template)
  end,
}
```

### Multiple Providers

You can add other providers (OpenAI, Anthropic, etc.) alongside Ollama:

```lua
providers = {
  ollama = { ... },  -- Local models
  openai = { ... },  -- Cloud fallback
}
```

## Research Sources

This configuration is based on extensive research from:
- Reddit r/LocalLLaMA community recommendations
- CodeGPT 2025 Developer's Guide
- Ollama model performance benchmarks
- Apple Silicon optimization guides
- JavaScript/Node.js developer feedback

## Model Details

### Qwen2.5-Coder 32B
- **Training**: 5.5 trillion tokens of code
- **Languages**: 92+ programming languages
- **Context**: Up to 128K tokens
- **Benchmark**: Competitive with GPT-4o on Aider code repair
- **Best for**: JavaScript, TypeScript, Node.js, React

### Yi-Coder 9B
- **Training**: Optimized for web development
- **Languages**: Python, JavaScript, Node.js, HTML, SQL
- **Context**: 128K tokens
- **Community**: Praised as "zippy" and effective
- **Best for**: Full-stack web development

### DeepSeek-Coder V2 16B
- **Training**: 2+ trillion tokens
- **Architecture**: Mixture-of-Experts (MoE)
- **Performance**: Rivals GPT-4 Turbo
- **Speed**: Faster than dense models due to MoE
- **Best for**: General coding, debugging, refactoring

## Next Steps

1. **Install Ollama**: `brew install ollama`
2. **Start Ollama**: `ollama serve`
3. **Pull a model**: `ollama pull qwen2.5-coder:32b-instruct-q4_K_M`
4. **Open Neovim**: `nvim`
5. **Start coding**: `:PrtChatNew` or select code and `:PrtComplete`

Enjoy your local AI coding assistant! 🦜
