# Erelego iOS orchestration SDK

This repository distributes `ErelegoKit.xcframework` through Swift Package Manager and CocoaPods. It contains the Erelego core SDK and its built-in custom adapters. Minimum supported iOS version: **15.0**.

The distribution version is **1.7.4**, preserving the source podspec's version. The bundled framework reports its existing core version **1.7.1**. This checkout has not been published or tagged.

## Swift Package Manager

In Xcode, add this checkout as a **local package** and select the **Erelego** library product. The package includes the local XCFramework and resolves Google Mobile Ads **13.2.0**, matching the version used to compile it.

For remote installation after this repository has been pushed and tagged, use `https://github.com/erelego-ads/orchestration-sdk-ios.git`. Do not assume a release tag exists yet.

Use `import ErelegoKit` in application code. The thin `Erelego` package module re-exports the framework without declaring another `Erelego` type that would shadow the SDK entry point. Its metadata helper is `ErelegoPackage.version()`.

## CocoaPods

Use the local podspec until the new repository is published:

```ruby
platform :ios, '15.0'

pod 'Erelego', :path => '../Erelego/orchestration-sdk-ios'
```

Adjust the path relative to your Podfile. Run `pod install`, then open the generated `.xcworkspace`. The podspec vendors `ErelegoKit.xcframework` and declares Google Mobile Ads **13.2.0**. After publishing a matching tag, Git-based integration can use the new repository URL and tag `1.7.4`.

## Initialize and request ads

```swift
import ErelegoKit

Erelego.sharedInstance().start { statuses in
    guard statuses != nil else {
        // Configuration/initialization failed; allow a retry.
        return
    }
    // Initialization completed. Start requests on the appropriate UI thread.
}

// Retain the loader and its delegate for the ad lifecycle.
let loader = ErelegoAdLoader()
loader.delegate = yourRetainedDelegate
loader.loadAd(adRequestConfiguration: AdRequestConfiguration(
    placement: yourExistingPlacementID,
    viewController: yourViewController
))
```

Implement the required `MediationAdDelegate` callbacks for your host. The framework supports banner, interstitial, rewarded, native, and other configured formats. Register the custom-event class as `ErelegoKit.ErelegoMediationCustomEvent` in your mediation configuration, retaining the existing server parameters.

## Backend compatibility

The XCFramework is copied from the Erelego source SDK without binary/string patching. The original Adster API endpoints, remote-configuration JSON keys, backend adapter IDs, and service plist are intentionally preserved. Backend placement IDs must not be renamed merely to change UI branding. Existing example IDs include:

```text
adster_banner_320x50
adster_banner_300x250
adster_native_test
adster_appopen_test
adster_interstitial_test
adster_unified_test
adster_rewarded_test
```

Their availability depends on the host's backend configuration. There is no additional Realm dependency in this distribution.

## Updating the binary

The source repository is the sibling `../erelego-ios-sdk`. Build a fresh artifact there using its packaging script, then copy the entire resulting `ErelegoKit.xcframework` into this repository's `Frameworks/` directory. Never rename the old binary or patch its embedded strings. Keep the Google dependency version and minimum iOS version aligned with the rebuilt framework.

Run `python3 scripts/verify_distribution.py` to verify both slices, exported module names, service configuration, and the recorded artifact hashes. Refresh the artifact hash manifest deliberately after rebuilding the binary. Generated builds and local Xcode state are ignored; the XCFramework itself is versioned for distribution.

The existing `AdsDemoSwiftUI` app remains connected to the Erelego **source** project for local development. To test this distribution in a host, remove that source framework dependency before adding this package or pod, so the SDK is not linked twice.

## Validation

Validated locally with Xcode 26.3:

- Swift package Release build for iOS Simulator (arm64 and x86_64) passed.
- An application-side type check using the package re-export, `Erelego.sharedInstance()`, `ErelegoAdLoader`, and original backend adapter IDs passed.
- `pod lib lint Erelego.podspec --allow-warnings` passed.
- Artifact verification passed for 34 files across both device and simulator slices, including the original endpoint literals and service configuration.

No remote release, CocoaPods publication, or Git tag was created.
