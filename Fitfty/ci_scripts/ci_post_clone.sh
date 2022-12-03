#!/bin/sh

brew install swiftlint

# Fitfty 디렉토리로 경로 이동 -> /Volumes/workspace/repository/Fitfty
cd ..

.tuist-bin/tuist fetch
.tuist-bin/tuist generate
