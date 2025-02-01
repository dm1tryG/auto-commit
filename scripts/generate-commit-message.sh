#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

COMMIT_MSG=$(python3 -c '
import json
import sys
import os
import subprocess
import random

EMOJI_MAP = {
    "feat": ["✨", "🚀", "🎉"],
    "fix": ["🐛", "🔧", "🚑"],
    "docs": ["📚", "📝", "📖"],
    "style": ["💄", "🎨", "✨"],
    "refactor": ["♻️", "🔨", "📦"],
    "test": ["✅", "🧪", "🔍"],
    "chore": ["🔧", "🧹", "⚙️"],
}

DEFAULT_EMOJIS = ["🎯", "🔄", "🌟"]

def get_emoji_for_message(message):
    commit_type = message.split(":", 1)[0].lower() if ":" in message else ""
    commit_type = commit_type.split("(")[0] if "(" in commit_type else commit_type
    emoji_list = EMOJI_MAP.get(commit_type, DEFAULT_EMOJIS)
    return random.choice(emoji_list)

def format_commit_message(message):
    parts = message.strip().split("\n", 1)
    title = parts[0].strip()
    body = parts[1].strip() if len(parts) > 1 else ""
    
    emoji = get_emoji_for_message(title)
    
    if ":" in title:
        type_part, desc_part = title.split(":", 1)
        desc_part = desc_part.strip()
        title = f"{type_part}:{emoji} {desc_part}"
    else:
        title = f"{emoji} {title}"
    
    return f"{title}\n\n{body}" if body else title

diff = subprocess.check_output(["git", "diff", "--cached"]).decode("utf-8")
if not diff:
    print("No changes staged for commit")
    sys.exit(1)

api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    print("OPENAI_API_KEY not found")
    sys.exit(1)

import urllib.request
import urllib.error

try:
    data = {
        "model": "gpt-3.5-turbo",
        "messages": [
            {
                "role": "system",
                "content": "You are a helpful assistant that generates concise and descriptive git commit messages. Follow the conventional commits specification. Focus on WHAT and WHY, not HOW. Start with a type (feat, fix, docs, style, refactor, test, chore) followed by a scope if applicable."
            },
            {
                "role": "user",
                "content": f"Generate a commit message for this diff:\n{diff}"
            }
        ],
        "temperature": 0.7,
        "max_tokens": 100
    }

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    req = urllib.request.Request(
        "https://api.openai.com/v1/chat/completions",
        data=json.dumps(data).encode(),
        headers=headers,
        method="POST"
    )

    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read())
        message = result["choices"][0]["message"]["content"]
        formatted_message = format_commit_message(message)
        print(formatted_message)

except Exception as e:
    print(f"Error: {str(e)}", file=sys.stderr)
    sys.exit(1)
')

if [ $? -ne 0 ]; then
    echo "Failed to generate commit message"
    exit 1
fi

git commit -m "$COMMIT_MSG"
git push
