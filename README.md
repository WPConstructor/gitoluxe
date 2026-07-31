<h1 align="center">Gitoluxe</h1>
<p align="center"><img src="https://wpconstructor.com/assets/images/logos/github/wpconstructor-gitoluxe.png" width="400"></p>

**AI-powered Conventional Commit message generation for Git.**

Gitoluxe is a lightweight Bash-based Git hook that automatically generates high-quality **Conventional Commit** messages using a local Large Language Model (LLM) running through **Ollama**.

Instead of manually writing commit messages, simply type `ai` (or leave the commit message empty) and Gitoluxe analyzes your staged changes to generate a structured Conventional Commit message that you can review, edit, or accept.
<br><br>

## Features

* 🤖 AI-generated Conventional Commit messages
* 🧠 Uses local LLMs via Ollama
* 🔒 Runs completely offline
* 🎯 Automatic commit type detection
* 📦 Automatic scope selection
* 📝 Multi-line commit body generation
* 🔍 Analyzes staged files, statistics and diff
* 🎨 Interactive terminal interface
* ✏ Edit before committing
* 🔄 Supports `git commit --amend`
* ⚙ Configurable through `gitoluxe.config.env`
* 📄 GPL-3.0 licensed
<br><br>

## Screenshot

<img src="https://wpconstructor.com/assets/images/readme/screenshots/gitoluxe-screenshot.jpg">
<br><br>

## Why Gitoluxe?

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
<br><br>

## Requirements

* Bash
* Git
* Ollama
* jq
* curl

Recommended:

* 6 GB RAM minimum
* Linux
* Any Ollama-compatible model
<br><br>

## Installation

Install Gitoluxe globally with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/WPConstructor/main/repoluxe.install.sh | bash
```

Or, if you prefer to download the installer first:

```bash
curl -fsSL -o repoluxe.install.sh https://raw.githubusercontent.com/WPConstructor/main/repoluxe.install.sh
bash repoluxe.install.sh
```

The installer will:

- Install Gitoluxe into your home directory
- Configure global Git hooks
- Install the `prepare-commit-msg` hook
- Create default configuration if needed
- Verify required dependencies
<br><br>

## Configuration

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

### Options

| Variable        | Description                  | Default  |
| --------------- | ---------------------------- | -------- |
| MODEL           | Ollama model                 | qwen3:4b |
| TEMPERATURE     | AI creativity                | 0        |
| MAX_INPUT_CHARS | Maximum diff size sent to AI | 7000     |
<br><br>

## Usage

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
<br><br>

## Interactive Menu

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
<br><br>

## AI Analysis

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
<br><br>

## Prompt Injection Protection

Source code comments can contain arbitrary text.

To prevent prompt injection, Gitoluxe sanitizes diff lines beginning with:

```text
#
//
/*
```

These are treated as source code comments instead of prompt instructions.
<br><br>

## Conventional Commit Support

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
<br><br>

## Generated Commit Example

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
<br><br>

## Supported Models

Any Ollama model may be used.

Examples:

* qwen3:4b
* qwen3:8b
* llama3
* mistral
* gemma
* deepseek

Running:

```
bash ~/gitoluxe/gitoluxe.config.sh
```
<br><br>

## Automatic Ollama Startup

If Ollama is not already running, Gitoluxe automatically starts it before generating the commit message.
<br><br>

## Amended Commits

`git commit --amend` is fully supported.

When no staged changes exist, Gitoluxe automatically analyzes the previous commit.
<br><br>

## Debug Information

The debug menu displays information such as:

* generation time
* diff size
* used model

Useful for benchmarking different models.
<br><br>

## License

Licensed under the GNU General Public License v3.0 or later.

See the `LICENSE` file for details.
<br><br>

## Author

**WPConstructor**

https://WPConstructor.com