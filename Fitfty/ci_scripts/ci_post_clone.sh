#!/bin/sh

brew install tuist
brew install swiftlint


cd ..
.tuist-bin/tuist fetch
.tuist-bin/tuist generate
