# WPConstructor Git AI 🚀

An AI-powered Git commit assistant using local LLMs (Ollama) to generate conventional commit messages directly inside Git hooks.

It enhances your workflow by analyzing staged changes and suggesting structured commit messages with interactive approval, editing, and diff inspection.

## ✨ Features

- 🧠 AI-generated conventional commit messages (feat, fix, chore, etc.)
- ⚡ Local inference via Ollama (no cloud required)
- 👀 Interactive commit menu:
  - Accept AI message
  - Add body suggestion (detailed commit explanation)
  - Edit AI message
  - Manual commit
  - Show staged changes
- 🔁 Generate up to 20 AI suggestions without leaving the menu
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
   - Accept 1-x → writes commit message
   - Add 5 suggestions
   - Create / Recreate Body
   - Remove Body
   - Show Changes → displays diff
   - Edit 1-x → opens editor
   - Manual → empty editor

## 🎮 Usage

After installation:

```
git add -A
git commit -m ""
```

You will see:

- AI-generated commit messages
- Interactive menu

Example:

```
==============================
🧠 AI Suggested Commit:
==============================
[1] refactor(githooks): clean up and standardize prepare-commit-msg script
[2] refactor(githooks): clean up prepare-commit-msg script
[3] fix(githooks): remove unnecessary backticks and formatting from commit body
[4] refactor(githooks): clean up prepare-commit-msg script
[5] refactor(githooks): clean up and optimize prepare-commit-msg script

No body
==============================

Accept [1-5], [A]dd 5 suggestions, Create/Recreate [B]ody, [S]how Changes, Edit [E1-E5], [M]anual
```

## 🔁 Menu Options

- **1-x**   → Accept AI commit message
- **A**     → Add 5 suggestions
- **B**     → Create/Recreate body
- **R**     → Remove body
- **S**     → Show staged diff
- **E1-Ex** → Edit AI suggestion
- **M**     → Write manual commit message

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