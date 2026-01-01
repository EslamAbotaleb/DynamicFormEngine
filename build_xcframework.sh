#!/bin/bash

set -e

FRAMEWORK_NAME="DynamicFormEngine"
SCHEME="DynamicFormEngine"
CONFIGURATION="Release"
BUILD_DIR="$(pwd)/build"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Common build flags
SWIFT_FLAGS="-no-verify-emitted-module-interface"

echo "▶️ Building iOS device framework"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "▶️ Building iOS simulator framework"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios-sim.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "📦 Creating XCFramework"
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$BUILD_DIR/ios-sim.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"

echo "✅ XCFramework created at:"
echo "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"
