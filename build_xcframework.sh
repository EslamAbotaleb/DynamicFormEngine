#!/bin/bash

set -e
set -o pipefail

# ----------------------------
# Usage: ./build-xcframework.sh FrameworkName SchemeName
# Example: ./build-xcframework.sh DynamicFormEngine DynamicFormEngine
# ----------------------------

FRAMEWORK_NAME=${1:?Please provide FRAMEWORK_NAME}
SCHEME=${2:-$FRAMEWORK_NAME}
CONFIGURATION="Release"
BUILD_DIR="$(pwd)/build"

SWIFT_FLAGS="-no-verify-emitted-module-interface"

# Clean old build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "▶️ Building iOS device framework for $FRAMEWORK_NAME"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "▶️ Building iOS simulator framework for $FRAMEWORK_NAME"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios-sim.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="$SWIFT_FLAGS"

echo "📦 Creating XCFramework for $FRAMEWORK_NAME"
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$BUILD_DIR/ios-sim.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"

echo "✅ XCFramework created at:"
echo "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"
