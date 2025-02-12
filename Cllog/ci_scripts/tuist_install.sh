#!/bin/sh

# mise 설치
curl https://mise.run | sh
"eval \"\$(/Users/local/.local/bin/mise activate zsh)\"" >> "/Users/local/.zshrc"

# tuist 설치
mise install tuist

cd ..

tuist install
tuist generate --no-open
