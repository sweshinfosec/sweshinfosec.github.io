#!/bin/bash
# commitpost.sh — BlackOps auto-publish to GitHub Pages
# Usage: ./commitpost.sh "Post title" path/to/walkthrough.md [path/to/session.json]
# Called by /commitpost skill after BlackOps assessment

SITE_DIR="$(cd "$(dirname "$0")" && pwd)"
POSTS_DIR="$SITE_DIR/_posts"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

TITLE="${1:-Untitled Walkthrough}"
SOURCE_MD="${2:-}"
SESSION_JSON="${3:-}"

# ── ENVIRONMENT GATE ──────────────────────────────────────────
# UAT and Prod are NEVER published publicly — client reports only
if [ -n "$SESSION_JSON" ] && [ -f "$SESSION_JSON" ]; then
  ENV=$(python3 -c "import json; d=json.load(open('$SESSION_JSON')); print(d.get('environment','unknown'))" 2>/dev/null)
  TARGET=$(python3 -c "import json; d=json.load(open('$SESSION_JSON')); print(d.get('target','unknown'))" 2>/dev/null)

  if [ "$ENV" = "uat" ] || [ "$ENV" = "prod" ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║         ⛔  PUBLISH BLOCKED — ENVIRONMENT GATE           ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║                                                          ║"
    printf "║  Environment : %-42s║\n" "$ENV"
    printf "║  Target      : %-42s║\n" "$TARGET"
    echo "║                                                          ║"
    echo "║  UAT / Prod assessments are NEVER published publicly.    ║"
    echo "║  Walkthrough delivered to client as private report only. ║"
    echo "║                                                          ║"
    echo "║  Allowed for public publish: lab | bugbounty only.       ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    exit 1
  fi
  echo "[commitpost] Environment: $ENV — publish allowed ✓"
fi
# ─────────────────────────────────────────────────────────────

# Slugify title
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
POST_FILE="$POSTS_DIR/${DATE}-${SLUG}.md"

if [ -n "$SOURCE_MD" ] && [ -f "$SOURCE_MD" ]; then
  # Check if front matter already exists
  if head -1 "$SOURCE_MD" | grep -q "^---"; then
    cp "$SOURCE_MD" "$POST_FILE"
  else
    # Inject Jekyll front matter
    cat > "$POST_FILE" << FRONTMATTER
---
title: "$TITLE"
date: $DATE
categories:
  - vapt
tags:
  - blackops
  - sweshinfosec
  - bug-bounty
excerpt: "BlackOps assessment walkthrough — $TITLE"
header:
  overlay_color: "#0d0d0d"
  overlay_filter: 0.9
---

FRONTMATTER
    cat "$SOURCE_MD" >> "$POST_FILE"
  fi
  echo "[commitpost] Post file created: $POST_FILE"
else
  echo "[commitpost] No source file provided — post file not created"
  exit 1
fi

# Git operations
cd "$SITE_DIR"

if [ ! -d ".git" ]; then
  echo "[commitpost] Initializing git repo..."
  git init
  git remote add origin https://github.com/sweshinfosec/sweshinfosec.github.io.git
  git branch -M main
fi

git add .
COMMIT_MSG="[BlackOps] $TITLE — $DATE $TIME"
git commit -m "$COMMIT_MSG"

echo "[commitpost] Pushing to GitHub..."
git push -u origin main

echo ""
echo "[commitpost] DONE — post will be live at:"
echo "  https://sweshinfosec.github.io/vapt/${SLUG}/"
