# WPConstructor Git AI 🚀

An AI-powered Git commit assistant using local LLMs (Ollama) to generate conventional commit messages directly inside Git hooks.

It enhances your workflow by analyzing staged changes and suggesting structured commit messages with interactive approval, editing, and diff inspection.

## ✨ Features

- 🧠 AI-generated conventional commit messages (feat, fix, chore, etc.)
- ⚡ Local inference via Ollama (no cloud required)
- 👀 Interactive commit menu:
  - Accept AI message
  - Edit AI message
  - Manual commit
  - Show staged changes
  - Regenerate suggestion
- 🔁 Regenerate AI suggestions without leaving the menu
- 🔒 Safe Git hook execution (no blocking or corruption)
- 🧩 Scope detection (githooks, cli, ai, installer, etc.)
- 📦 Lightweight installation script

## 🧠 How it works

The system hooks into Git’s `prepare-commit-msg` process:

1. Captures staged changes (`git diff --cached`)
2. Sends diff to local LLM (Ollama)
3. Generates a conventional commit message
4. Shows interactive menu
5. User selects action:
   - Accept → writes commit message
   - Regenerate → re-runs AI
   - Show Changes → displays diff
   - Edit → opens editor
   - Manual → empty editor

## 📦 Requirements

- Git (installed in install path [git init])
- Bash

## 🚀 Installation

Download & Run installer in bash (CLI):

```
curl -fsSL https://raw.githubusercontent.com/WPConstructor/ai-git/v0.1.0/git-ai-install.sh | bash
```

This will:
- Install Ollama (if missing)
- Pull `qwen2.5-coder:7b` model
- Install Git hook into `.githooks/`
- Enable `core.hooksPath`

## ⚙️ Git Hook Setup

The system uses a custom hooks directory:

```
git config core.hooksPath .githooks
```

Hook file:
```
.githooks/prepare-commit-msg
```

## 🎮 Usage

After installation:

```
git add -A
git commit -m ""
```

You will see:

- AI-generated commit message
- Interactive menu

Example:

```
==============================
🧠 AI Suggested Commit:
==============================
feat(githooks): add staged diff preview before commit
==============================

[A]ccept, [R]egenerate, [S]how Changes, [E]dit, [M]anual ?
```

## 🔁 Menu Options

- **A** → Accept AI commit message
- **R** → Regenerate AI commit
- **S** → Show staged diff
- **E** → Edit AI suggestion
- **M** → Write manual commit message

## 🧠 Conventional Commit Style

The AI follows:

```
type(scope): description
```

Types:

- feat → new feature
- fix → bug fix
- chore → maintenance
- refactor → code restructuring
- docs → documentation
- test → tests
- ci → CI/CD changes
- build → build system changes

## ⚠️ Notes

- This tool runs locally using Ollama
- No external API calls are required
- Large diffs are truncated for performance
- Uses `qwen2.5-coder:7b` model

## 🧪 Example Output

```
feat(cli): add interactive commit selection menu
```

```
fix(ai): handle empty diff generation safely
```

```
chore(githooks): improve commit hook stability
```

## 📁 Project Structure

```
.githooks/
  prepare-commit-msg

install.sh
README.md
LICENSE.md
```

## ⚖️ License

This project is licensed under the MIT License.

See the full license text here:  
👉 [LICENSE.md](LICENSE.md)

## 🧑‍💻 Author

Built by WPConstructor  
[Contact WPConstructor](https://wpconstructor.com/contact/)