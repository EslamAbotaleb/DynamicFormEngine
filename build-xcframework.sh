#!/bin/bash
# ------------------------------------------------------------------------------
# XCFramework Build Script
# ------------------------------------------------------------------------------
# Builds an iOS + iOS Simulator XCFramework with library evolution enabled
#
# Source (original idea):
# https://stackoverflow.com/a/ (Gil, modified by community)
# Retrieved: 2026-01-02
# License: CC BY-SA 4.0
# ------------------------------------------------------------------------------

set -e          # ❌ Exit immediately on error
set -o pipefail # ❌ Fail if any command in a pipe fails

# ------------------------------------------------------------------------------
# ⚙️ Configuration
# ------------------------------------------------------------------------------
FRAMEWORK_NAME="DynamicFormEngine"
CONFIGURATION="Debug"
BUILD_DIR="./build"

IOS_ARCHIVE_PATH="$BUILD_DIR/$FRAMEWORK_NAME.framework-iphoneos.xcarchive"
SIM_ARCHIVE_PATH="$BUILD_DIR/$FRAMEWORK_NAME.framework-iphonesimulator.xcarchive"
XCFRAMEWORK_PATH="$BUILD_DIR/$FRAMEWORK_NAME.xcframework"

echo "🚀 Starting XCFramework build for: $FRAMEWORK_NAME"

# ------------------------------------------------------------------------------
# 🧹 Clean previous build
# ------------------------------------------------------------------------------
echo "🧹 Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# ------------------------------------------------------------------------------
# 📱 Build iOS (device) framework
# ------------------------------------------------------------------------------
echo "📱 Archiving iOS (device) framework..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS" \
  -archivePath "$IOS_ARCHIVE_PATH" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# ------------------------------------------------------------------------------
# 🖥️ Build iOS Simulator framework
# ------------------------------------------------------------------------------
echo "🖥️ Archiving iOS Simulator framework..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -configuration "$CONFIGURATION" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$SIM_ARCHIVE_PATH" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# ------------------------------------------------------------------------------
# 🛠️ Fix Swift .swiftinterface bug (SR-14195 / SR-898)
# ------------------------------------------------------------------------------
echo "🛠️ Fixing Swift .swiftinterface references (SR-14195)..."

SWIFTINTERFACE_PATTERN="$IOS_ARCHIVE_PATH/Products/Library/Frameworks/$FRAMEWORK_NAME.framework/Modules/$FRAMEWORK_NAME.swiftmodule/*.swiftinterface"

grep -rli "$FRAMEWORK_NAME.$FRAMEWORK_NAME" $SWIFTINTERFACE_PATTERN \
  | xargs sed -i '' "s,$FRAMEWORK_NAME.$FRAMEWORK_NAME,$FRAMEWORK_NAME,g" || true

echo "✅ Swift interface fix applied"

# ------------------------------------------------------------------------------
# 📦 Create XCFramework
# ------------------------------------------------------------------------------
echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$IOS_ARCHIVE_PATH/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$SIM_ARCHIVE_PATH/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$XCFRAMEWORK_PATH"

# ------------------------------------------------------------------------------
# ✅ Verification
# ------------------------------------------------------------------------------
echo "🔍 Verifying XCFramework output..."
if [[ ! -d "$XCFRAMEWORK_PATH" ]]; then
  echo "❌ ERROR: XCFramework was not created!"
  exit 1
fi

# ------------------------------------------------------------------------------
# 🎉 Done
# ------------------------------------------------------------------------------
echo "🎉 Success!"
echo "📍 XCFramework location:"
echo "   $XCFRAMEWORK_PATH"
