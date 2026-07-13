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