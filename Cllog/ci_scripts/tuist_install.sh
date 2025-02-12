#!/bin/sh

curl -Ls https://install.tuist.io | bash

cd ..

tuist install
tuist generate --no-open
