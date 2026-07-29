#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./create_repo.sh <repository-name>"
    exit 1
fi

REPO_ROOT="../repositories"

mkdir -p "$REPO_ROOT"

REPO_PATH="$REPO_ROOT/$1.git"

if [ -d "$REPO_PATH" ]; then
    echo "Error: Repository '$1' already exists."
    exit 1
fi

git init --bare "$REPO_PATH"

echo "Repository created successfully!"
echo "Location: $REPO_PATH"