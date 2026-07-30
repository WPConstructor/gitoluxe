# Gitoluxe

**AI-powered Conventional Commit message generation for Git.**

Gitoluxe is a lightweight Bash-based Git hook that automatically generates high-quality **Conventional Commit** messages using a local Large Language Model (LLM) running through **Ollama**.

Instead of manually writing commit messages, simply type `ai` (or leave the commit message empty) and Gitoluxe analyzes your staged changes to generate a structured Conventional Commit message that you can review, edit, or accept.

---

## Features

* 🤖 AI-generated Conventional Commit messages
* 🧠 Uses local LLMs via Ollama
* 🔒 Runs completely offline
* ⚡ Fast Bash implementation
* 🎯 Automatic commit type detection
* 📦 Automatic scope selection
* 📝 Multi-line commit body generation
* 🔍 Analyzes staged files, statistics and diff
* 🚫 Ignores formatting-only and comment-only changes
* 🛡 Prompt injection protection for source code comments
* 🎨 Interactive terminal interface
* ✏ Edit before committing
* 🔄 Supports `git commit --amend`
* ⚙ Configurable through `gitoluxe.config.env`
* 📄 GPL-3.0 licensed

---

# Why Gitoluxe?

Writing good commit messages is repetitive.

Gitoluxe analyzes what actually changed and generates a Conventional Commit message that emphasizes the **primary purpose** of the commit while preserving important secondary changes in the commit body.

Example:

```text
feat(auth): add OAuth login

Added GitHub authentication.
Added Google authentication.
Updated login tests.
Improved configuration handling.
```

---

# Requirements

* Bash
* Git
* Ollama
* jq
* curl

Recommended:

* 6 GB RAM minimum
* Linux or macOS
* Any Ollama-compatible model

---

# Installation

Clone the repository.

```bash
git clone https://github.com/WPConstructor/gitoluxe.git
cd gitoluxe
```

Install the Git hook.

```bash
cp prepare-commit-msg .git/hooks/
chmod +x .git/hooks/prepare-commit-msg
```

---

# Install Ollama

Install Ollama from:

https://ollama.com

Start the server:

```bash
ollama serve
```

Download a model.

Example:

```bash
ollama pull qwen3:4b
```

---

# Configuration

Create a configuration file.

```text
gitoluxe.config.env
```

Example:

```ini
MODEL=qwen3:4b
TEMPERATURE=0
MAX_INPUT_CHARS=7000
```

## Options

| Variable        | Description                  | Default  |
| --------------- | ---------------------------- | -------- |
| MODEL           | Ollama model                 | qwen3:4b |
| TEMPERATURE     | AI creativity                | 0        |
| MAX_INPUT_CHARS | Maximum diff size sent to AI | 7000     |

---

# Usage

Stage your files.

```bash
git add .
```

Start a commit.

```bash
git commit
```

Leave the commit message empty or enter:

```text
ai
```

The hook launches automatically.

---

# Interactive Menu

After generation, Gitoluxe displays the generated commit.

Example:

```text
Subject:

feat(config): add AI configuration support

Body:

Added fallback configuration loading.
Improved validation.
Added exit command.
```

Available actions:

| Key   | Action              |
| ----- | ------------------- |
| **C** | Commit              |
| **E** | Edit message        |
| **R** | Remove body         |
| **S** | Show staged changes |
| **D** | Debug information   |
| **X** | Cancel commit       |

---

# AI Analysis

The AI receives three sources of information.

* Staged file list
* Git statistics
* Unified git diff

The prompt instructs the model to:

* identify the primary change
* classify secondary changes
* generate a Conventional Commit
* ignore formatting-only changes
* ignore comment-only changes
* ignore generated files
* ignore lockfiles
* avoid hallucinating changes
* return strict JSON

---

# Prompt Injection Protection

Source code comments can contain arbitrary text.

To prevent prompt injection, Gitoluxe sanitizes diff lines beginning with:

```text
#
//
/*
```

These are treated as source code comments instead of prompt instructions.

---

# Conventional Commit Support

Supported types include:

* feat
* fix
* refactor
* style
* docs
* test
* perf
* chore
* build
* ci
* security
* deps
* release
* remove
* cleanup
* ui
* i18n

Scopes are automatically inferred from the primary subsystem.

Examples:

```text
hooks
auth
api
ui
config
core
parser
database
network
validation
```

---

# Generated Commit Example

Input:

```text
Added OAuth login.
Updated tests.
Improved configuration loading.
```

Generated:

```text
feat(auth): add OAuth login

Updated authentication tests.
Improved configuration loading.
```

---

# Supported Models

Any Ollama model may be used.

Examples:

* qwen3:4b
* qwen3:8b
* llama3
* mistral
* gemma
* deepseek

Changing models only requires editing:

```ini
MODEL=qwen3:4b
```

---

# Automatic Ollama Startup

If Ollama is not already running, Gitoluxe automatically starts it before generating the commit message.

---

# Amended Commits

`git commit --amend` is fully supported.

When no staged changes exist, Gitoluxe automatically analyzes the previous commit.

---

# Debug Information

The debug menu displays information such as:

* generation time
* diff size
* prompt size

Useful for benchmarking different models.

---

# Exit Conditions

The hook exits immediately when:

* running inside CI
* merge commits
* squash commits
* template commits
* user already supplied a commit message
* nothing is staged

---

# Project Structure

```text
.
├── prepare-commit-msg
├── gitoluxe.config.env
├── README.md
└── LICENSE
```
---

# License

Licensed under the GNU General Public License v3.0 or later.

See the `LICENSE` file for details.

---

# Author

**WPConstructor**

https://WPConstructor.com

# Gitoluxe

AI-powered Git commit automation running locally and keeping your code private.

Gitoluxe uses local AI models such as **Qwen2.5-Coder 7B or 3B** through Ollama to generate meaningful Git commit messages from your code changes. Since the AI runs locally, your source code and diffs never leave your machine.

## Features

- 🤖 **Local AI commit messages**
  - Uses Qwen2.5-Coder models locally.
  - No cloud APIs.
  - Your code stays private.

- 🔒 **Privacy focused**
  - Code changes are analyzed only on your own computer.
  - No external services required.

- ⚙️ **Global Git integration**
  - Installs into your home directory.
  - Configures Git hooks globally.
  - Works automatically across your repositories.

- ✍️ **AI-assisted commits**
  - Generates Conventional Commit messages.
  - Creates structured commit messages from your diff.
  - Helps keep commit history clean and consistent.

- ⚠️ **Main branch protection**
  - Detects commits directly to `main`.
  - Warns before committing because direct commits to main may not be desired.

- 🚀 **Pre-push checks**
  - Adds Git pre-push integration.
  - Runs `repoluxe.sh` from your repository before pushing.
  - Supports checks before pushing normal commits or tags.

## How It Works

```
Git commit
    |
    v
Gitoluxe
    |
    v
Local Qwen2.5-Coder model
    |
    v
Generated commit message
```

Before pushing:

```
git push
    |
    v
pre-push hook
    |
    v
./repoluxe.sh
    |
    v
Push allowed or blocked
```

## Requirements

- Git
- Ollama
- A supported local model:
  - `qwen2.5-coder:7b`
  - `qwen2.5-coder:3b`

Install Ollama:

https://ollama.com

Download a model:

```
ollama pull qwen2.5-coder:7b
```

## Installation

Clone the repository:

```
git clone https://github.com/wpconstructor/gitoluxe.git
cd gitoluxe
```

Install:

```
./install.sh
```

Gitoluxe installs itself into your home directory and configures global Git hooks.

## Usage

After installation, use Git normally:

```
git add .
git commit
```

Gitoluxe analyzes your changes and generates a commit message.

You can edit the generated message before committing.

## Commit Example

Generated output:

```
feat(api): add webhook validation

Added request validation.
Improved API error handling.
Added integration tests.
```

## Repository Pre-Push Checks

To add custom checks for a repository, create:

```
repoluxe.sh
```

Example:

```
#!/bin/bash

echo "Running pre-push checks..."

npm test
npm run lint
```

Make it executable:

```
chmod +x repoluxe.sh
```

Gitoluxe executes it before pushing.

## Privacy

Gitoluxe is designed for private development workflows.

Your:

- source code
- git diff
- commit context

stay on your machine and are processed by your local Ollama model.

No external AI service is required.

## Configuration

Gitoluxe uses local configuration and Git hooks.

Supported models:

```
qwen2.5-coder:7b
qwen2.5-coder:3b
```

Smaller models provide faster generation.
Larger models provide more detailed commit messages.

## Why Gitoluxe?

Modern AI coding tools are powerful, but many require sending code to external servers.

Gitoluxe provides:

- local AI
- private code analysis
- automated commits
- better Git workflows

without leaving your development environment.

## License

See the LICENSE file for details.