# GRAVITON: Solar Conquest — iOS (native Swift shell)

A native Swift / WKWebView wrapper around the self-contained
`graviton-v5.html` canvas game. No Capacitor, no Node, no CocoaPods —
just an Xcode project you can open and run.

## Build & run

1. Open `Graviton.xcodeproj` in Xcode 15+.
2. Select a simulator or a connected device.
3. Set your Team under **Signing & Capabilities** (needed for a real device).
4. Press ⌘R.

Deployment target: **iOS 15.0**. Devices: **iPhone + iPad**.

## What's inside

```
Graviton/
├── Graviton.xcodeproj/           # the Xcode project
└── Graviton/
    ├── AppDelegate.swift          # window + root view controller (no storyboards/scenes)
    ├── GameViewController.swift    # full-screen WKWebView host for the game
    ├── graviton-v5.html            # the complete game (bundled resource)
    ├── Info.plist                  # full-screen, orientations, hidden status bar, launch colour
    └── Assets.xcassets/
        ├── AppIcon.appiconset      # drop a 1024×1024 PNG here before shipping
        └── LaunchBackground.colorset # #03030c void colour for the launch screen
```

## How the shell works

- `GameViewController` loads `graviton-v5.html` from the app bundle with
  `loadFileURL(_:allowingReadAccessTo:)` — everything runs locally, no network.
- Scrolling, bouncing, and zoom are disabled on the web view's scroll view so
  the canvas owns all touch gestures.
- `allowsInlineMediaPlayback` + `mediaTypesRequiringUserActionForPlayback = []`
  are set so future Web Audio SFX (see roadmap) can play without a tap.
- The idle timer is disabled while the game is on screen so it never dims mid-play.
- Status bar and home indicator are hidden; `UIRequiresFullScreen` is set.

## Before App Store submission

- **App icon:** add a 1024×1024 PNG to `Assets.xcassets/AppIcon.appiconset`.
- **Bundle ID:** change `com.yourname.graviton` (in the target build settings)
  to your own reverse-DNS identifier.
- **Signing team:** set it in Xcode's Signing & Capabilities tab.
- Metadata (name, subtitle, keywords, description) is in `GRAVITON_HANDOFF.md`.

## Updating the game

The game is a single file. To ship a new build, replace
`Graviton/graviton-v5.html` with the new version and rebuild — no other
changes needed.
