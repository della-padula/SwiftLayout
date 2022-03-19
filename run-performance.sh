#!/bin/sh
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max"
xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies -Xfrontend -warn-long-expression-type-checking=10 -Xfrontend -warn-long-function-bodies=10" |
        grep -o "^\d*.\d*ms\t[^$]*$" |
        awk '!visited[$0]++' |
        sed -e "s|$(pwd)/||" |
        grep -v "Tests" |
        sort -n
xcrun simctl delete swiftlayouttest
