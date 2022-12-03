#!/bin/sh

brew install swiftlint

pwd
cd ..
pwd

.tuist-bin/tuist fetch
.tuist-bin/tuist generate
