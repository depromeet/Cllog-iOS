#!/bin/sh

brew install tuist

cd ..

tuist install
tuist generate --no-open
