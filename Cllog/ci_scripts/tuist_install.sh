#!/bin/sh

# mise 설치
curl https://mise.run | sh

# tuist 설치
mise install tuist

cd ..

tuist install
tuist generate --no-open
