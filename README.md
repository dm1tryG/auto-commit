# AI Commit Message Generator

A utility for automatically generating meaningful commit messages using OpenAI API.

## Features
- 🤖 Automatic commit message generation based on git diff
- 🎯 Conventional commits format support
- 😊 Automatic emoji insertion after type colon
- 🚀 Fully automated process (no interactive prompts)
- 📝 Multi-line commit messages support
- 🔄 Automatic push after commit

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd auto-commit
```

2. Create `.env` file and add your OpenAI API key:
```bash
OPENAI_API_KEY=your-key-here
```

3. Make the script executable:
```bash
chmod +x scripts/generate-commit-message.sh
```

## Usage

To create a commit simply use:
```bash
make commit
```

The script will automatically:
1. Add all changes to staging area
2. Generate a meaningful commit message with emoji
3. Create a commit
4. Push changes

## Example Messages

- `feat:✨ Add new authentication system`
- `fix:🐛 Resolve memory leak in background tasks`
- `docs:📚 Update deployment instructions`
- `style:💄 Improve code formatting`
- `refactor:♻️ Optimize database queries`
- `test:✅ Add unit tests for auth module`
- `chore:🔧 Update dependencies`

## Requirements
- Python 3.x
- Git
- Make

## Project Structure
```
.
├── .env                           # Environment variables
├── Makefile                       # Make commands
├── README.md                      # Documentation
└── scripts/
    └── generate-commit-message.sh # Main script
```
