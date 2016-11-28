#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"
  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS} --preserve-metadata=identifier,entitlements \"$1\""
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS} --preserve-metadata=identifier,entitlements "$1"
  fi
}

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  # Get architectures for current file
  archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"
  stripped=""
  for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary" || exit 1
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworkActivityLogger/AFNetworkActivityLogger.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFOAuth1Client/AFOAuth1Client.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ALPValidator/ALPValidator.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARAnalytics/ARAnalytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARCollectionViewMasonryLayout/ARCollectionViewMasonryLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARGenericTableViewController/ARGenericTableViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARTiledImageView/ARTiledImageView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Adjust/Adjust.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Aerodramus/Aerodramus.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Analytics/Analytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AppHub/AppHub.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIColors/Artsy_UIColors.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIFonts/Artsy_UIFonts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UILabels/Artsy_UILabels.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy-UIButtons/Artsy_UIButtons.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/CocoaLumberjack/CocoaLumberjack.framework"
  install_framework "$BUILT_PRODUCTS_DIR/DHCShakeNotifier/DHCShakeNotifier.framework"
  install_framework "$BUILT_PRODUCTS_DIR/EDColor/EDColor.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Emission/Emission.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Extraction/Extraction.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FLKAutoLayout/FLKAutoLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FXBlurView/FXBlurView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/HockeySDK-Source/HockeySDK_Source.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ISO8601DateFormatter/ISO8601DateFormatter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Interstellar/Interstellar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JLRoutes/JLRoutes.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSBadgeView/JSBadgeView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSDecoupledAppDelegate/JSDecoupledAppDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JWTDecode/JWTDecode.framework"
  install_framework "$BUILT_PRODUCTS_DIR/KSDeferred/KSDeferred.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Keys/Keys.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MARKRangeSlider/MARKRangeSlider.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MMMarkdown/MMMarkdown.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MultiDelegate/MultiDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NAMapKit/NAMapKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NPKeyboardLayoutGuide/NPKeyboardLayoutGuide.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORKeyboardReactingApplication/ORKeyboardReactingApplication.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORStackView/ORStackView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ObjectiveSugar/ObjectiveSugar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/RSSwizzle/RSSwizzle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/React/React.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ReactiveCocoa/ReactiveCocoa.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDWebImage/SDWebImage.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SSFadingScrollView/SSFadingScrollView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Starscream/Starscream.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SwiftyJSON/SwiftyJSON.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Then/Then.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertView+Blocks/UIAlertView_Blocks.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UICKeyChainStore/UICKeyChainStore.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView+BooleanAnimations/UIView_BooleanAnimations.framework"
  install_framework "$BUILT_PRODUCTS_DIR/VCRURLConnection/VCRURLConnection.framework"
  install_framework "$BUILT_PRODUCTS_DIR/iRate/iRate.framework"
fi
if [[ "$CONFIGURATION" == "Store" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworkActivityLogger/AFNetworkActivityLogger.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFOAuth1Client/AFOAuth1Client.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ALPValidator/ALPValidator.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARAnalytics/ARAnalytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARCollectionViewMasonryLayout/ARCollectionViewMasonryLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARGenericTableViewController/ARGenericTableViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARTiledImageView/ARTiledImageView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Adjust/Adjust.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Aerodramus/Aerodramus.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Analytics/Analytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AppHub/AppHub.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIColors/Artsy_UIColors.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIFonts/Artsy_UIFonts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UILabels/Artsy_UILabels.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy-UIButtons/Artsy_UIButtons.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/CocoaLumberjack/CocoaLumberjack.framework"
  install_framework "$BUILT_PRODUCTS_DIR/DHCShakeNotifier/DHCShakeNotifier.framework"
  install_framework "$BUILT_PRODUCTS_DIR/EDColor/EDColor.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Emission/Emission.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Extraction/Extraction.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FLKAutoLayout/FLKAutoLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FXBlurView/FXBlurView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/HockeySDK-Source/HockeySDK_Source.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ISO8601DateFormatter/ISO8601DateFormatter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Interstellar/Interstellar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JLRoutes/JLRoutes.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSBadgeView/JSBadgeView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSDecoupledAppDelegate/JSDecoupledAppDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JWTDecode/JWTDecode.framework"
  install_framework "$BUILT_PRODUCTS_DIR/KSDeferred/KSDeferred.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Keys/Keys.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MARKRangeSlider/MARKRangeSlider.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MMMarkdown/MMMarkdown.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MultiDelegate/MultiDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NAMapKit/NAMapKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NPKeyboardLayoutGuide/NPKeyboardLayoutGuide.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORKeyboardReactingApplication/ORKeyboardReactingApplication.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORStackView/ORStackView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ObjectiveSugar/ObjectiveSugar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/RSSwizzle/RSSwizzle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/React/React.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ReactiveCocoa/ReactiveCocoa.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDWebImage/SDWebImage.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SSFadingScrollView/SSFadingScrollView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Starscream/Starscream.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SwiftyJSON/SwiftyJSON.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Then/Then.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertView+Blocks/UIAlertView_Blocks.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UICKeyChainStore/UICKeyChainStore.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView+BooleanAnimations/UIView_BooleanAnimations.framework"
  install_framework "$BUILT_PRODUCTS_DIR/VCRURLConnection/VCRURLConnection.framework"
  install_framework "$BUILT_PRODUCTS_DIR/iRate/iRate.framework"
fi
if [[ "$CONFIGURATION" == "Demo" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworkActivityLogger/AFNetworkActivityLogger.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AFOAuth1Client/AFOAuth1Client.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ALPValidator/ALPValidator.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARAnalytics/ARAnalytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARCollectionViewMasonryLayout/ARCollectionViewMasonryLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARGenericTableViewController/ARGenericTableViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ARTiledImageView/ARTiledImageView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Adjust/Adjust.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Aerodramus/Aerodramus.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Analytics/Analytics.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AppHub/AppHub.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIColors/Artsy_UIColors.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UIFonts/Artsy_UIFonts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy+UILabels/Artsy_UILabels.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Artsy-UIButtons/Artsy_UIButtons.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/CocoaLumberjack/CocoaLumberjack.framework"
  install_framework "$BUILT_PRODUCTS_DIR/DHCShakeNotifier/DHCShakeNotifier.framework"
  install_framework "$BUILT_PRODUCTS_DIR/EDColor/EDColor.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Emission/Emission.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Extraction/Extraction.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FLKAutoLayout/FLKAutoLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FXBlurView/FXBlurView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/HockeySDK-Source/HockeySDK_Source.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ISO8601DateFormatter/ISO8601DateFormatter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Interstellar/Interstellar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JLRoutes/JLRoutes.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSBadgeView/JSBadgeView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JSDecoupledAppDelegate/JSDecoupledAppDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/JWTDecode/JWTDecode.framework"
  install_framework "$BUILT_PRODUCTS_DIR/KSDeferred/KSDeferred.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Keys/Keys.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MARKRangeSlider/MARKRangeSlider.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MMMarkdown/MMMarkdown.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MultiDelegate/MultiDelegate.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NAMapKit/NAMapKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NPKeyboardLayoutGuide/NPKeyboardLayoutGuide.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORKeyboardReactingApplication/ORKeyboardReactingApplication.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ORStackView/ORStackView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ObjectiveSugar/ObjectiveSugar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/RSSwizzle/RSSwizzle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/React/React.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ReactiveCocoa/ReactiveCocoa.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDWebImage/SDWebImage.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SSFadingScrollView/SSFadingScrollView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Starscream/Starscream.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SwiftyJSON/SwiftyJSON.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Then/Then.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertView+Blocks/UIAlertView_Blocks.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UICKeyChainStore/UICKeyChainStore.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView+BooleanAnimations/UIView_BooleanAnimations.framework"
  install_framework "$BUILT_PRODUCTS_DIR/VCRURLConnection/VCRURLConnection.framework"
  install_framework "$BUILT_PRODUCTS_DIR/iRate/iRate.framework"
fi
