#!/bin/sh

brew install tuist
export PATH="/opt/homebrew/bin:$PATH"

cd ..

tuist install
tuist generate --no-open
