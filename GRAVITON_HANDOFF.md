# GRAVITON: Solar Conquest — iOS & Claude Code Handoff

## What This Is
A self-contained HTML5 canvas game (~1500 lines, zero dependencies) ready to wrap for iOS using Capacitor or a WKWebView shell. All physics, rendering, and game logic live in a single `graviton-v5.html` file.

---

## iOS Packaging (Capacitor.js — Recommended)

### Step 1 — Install Capacitor
```bash
npm init -y
npm install @capacitor/core @capacitor/cli @capacitor/ios
npx cap init "GRAVITON Solar Conquest" "com.yourname.graviton" --web-dir dist
```

### Step 2 — Copy the game file
```bash
mkdir dist
cp graviton-v5.html dist/index.html
```

### Step 3 — Add iOS platform
```bash
npx cap add ios
npx cap sync ios
npx cap open ios   # opens in Xcode
```

### Step 4 — Xcode settings
- **Display Name:** GRAVITON: Solar Conquest
- **Bundle ID:** com.yourname.graviton
- **Deployment Target:** iOS 15+
- **Device:** iPhone + iPad (landscape supported)
- **Orientation:** Portrait + Landscape (the canvas auto-sizes)
- In `Info.plist` add: `UIRequiresFullScreen = YES`
- In `capacitor.config.json` add: `"backgroundColor": "#03030c"`

### Step 5 — Disable bounce scroll (add to AppDelegate.swift)
```swift
// In application(_:didFinishLaunchingWithOptions:)
// Already handled by touch-action:none in CSS
```

### capacitor.config.json
```json
{
  "appId": "com.yourname.graviton",
  "appName": "GRAVITON Solar Conquest",
  "webDir": "dist",
  "backgroundColor": "#03030c",
  "ios": {
    "contentInset": "never",
    "preferredContentMode": "mobile"
  }
}
```

---

## Alternative: Pure Swift WKWebView (lighter weight)

```swift
import WebKit

class GameViewController: UIViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        view.addSubview(webView)
        view.backgroundColor = UIColor(red: 0.012, green: 0.012, blue: 0.047, alpha: 1)
        if let url = Bundle.main.url(forResource: "graviton-v5", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    override var prefersStatusBarHidden: Bool { return true }
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
}
```

Add `graviton-v5.html` to the Xcode project's target (Copy Bundle Resources).

---

## App Store Metadata

| Field | Value |
|---|---|
| Name | GRAVITON: Solar Conquest |
| Subtitle | Smash worlds. Grow. Conquer. |
| Category | Games → Simulation / Arcade |
| Rating | 4+ |
| Keywords | space, solar system, planet, physics, arcade, astronomy, smash |
| Description | You are Earth. Use real JPL orbital mechanics to navigate 100+ bodies across our solar system and beyond. Drag nearby worlds into your gravity well, hard-smash planets bigger than you, earn coins, and upgrade your cosmic arsenal. Travel to exoplanet systems including TRAPPIST-1's 7 worlds. Real science. Pure destruction. |
| Privacy | No data collected. No network required after install. |

### Screenshots needed (6.5" iPhone)
1. Solar system view with elastic connection lines glowing
2. Dragging Earth toward Saturn — "⚡ HARD SMASH!" indicator
3. Upgrade shop open with coins displayed
4. TRAPPIST-1 system view (zoomed out, 7 planets orbiting)
5. Level-up flash overlay
6. Post-smash shockwave particle burst

---

## Claude Code Next Steps

Hand this spec to Claude Code in a new session with:

```
"I have a self-contained HTML5 game file (graviton-v5.html). 
Please set up a Capacitor iOS project to wrap it and prepare 
for App Store submission. The game uses canvas 2D, touch events, 
and no external network calls. Target iOS 15+."
```

### Key files to hand over
- `graviton-v5.html` — the complete game
- `GRAVITON_HANDOFF.md` — this document
- `capacitor.config.json` — (Claude Code creates this)
- `package.json` — (Claude Code creates this)

---

## Architecture Notes for Developers

### Game Loop
```
startGame() → requestAnimationFrame(gameLoop)
  gameLoop(ts):
    update(dt)          // orbital mechanics + spring physics
    draw()              // canvas 2D render
    updateSidePanel()   // HUD DOM updates
```

### Key Data Structures

**BODIES array** — all solar system objects:
- `pos: {x, y}` — world-space AU coordinates
- `orb` — Keplerian orbital elements for `advanceOrbits()`
- `disp: {x,y}` / `vel: {x,y}` — spring displacement from orbital position
- `bodyLevel` / `bodyMaxLevel` — HP-like layer system
- `alive: bool` — false when fully absorbed

**EXOPLANET_BODIES array** — 14 exoplanets across 6 star systems:
- Same structure as BODIES but position updated via circular orbit around `starRef`
- Only rendered/connected when `cam.zoom < 12` (galactic view)

**player object:**
- `pos` — current screen position (can be displaced from orbX/orbY during drag)
- `orbX/orbY` — orbital anchor point (springs back here)
- `mass` — grows with absorptions
- `coins` — currency for UPGRADES

**UPGRADES array** — 6 purchasable upgrades:
- Effects applied immediately in `buyUpgrade(id)`
- Moon upgrade physically adds entries to `player.body.moons[]`

### Physics Summary
- `advanceOrbits(dt)` — Kepler equation per body, sets `orbX/orbY`
- `physicsUpdate(dt)` — spring force toward orbital position + player gravity pull
- `smashImpulse(wx,wy,mass)` — radial velocity impulse to all nearby bodies
- `perturbOrbit(body)` — random delta to `e`, `L0`, `peri` after any smash

### Smash Logic
```
Normal smash (mass ≤ 1.05× player): full XP + coins, bodyLevel -= 1
Hard smash (mass 1.05–3× player):   partial XP, HP damage, bodyLevel -= 1
bodyLevel reaches 0:                  body destroyed + mass absorbed
```

### Coordinate System
- World: AU-scale, origin = Sun, y-up
- Screen: canvas pixels, `w2s(wx,wy)` → `{sx,sy}`, `s2w(sx,sy)` → `{wx,wy}`
- `cam.zoom` = pixels per AU (100 = default solar system view)

---

## Feature Roadmap (v6+ ideas)
- [ ] Game Center leaderboard integration (total mass absorbed)
- [ ] Sound effects via Web Audio API (no external files needed)
- [ ] Dark matter / nebula zones with drag effects
- [ ] Multiplayer: two Earths racing to absorb the most mass
- [ ] Planet Nine procedurally generated at extreme Oort distances
- [ ] Haptic feedback on smash (Capacitor Haptics plugin)
- [ ] iCloud save via Capacitor Preferences plugin
- [ ] Achievements: "Galaxy Brain" (travel to 5 star systems), "Titan Killer" (hard-smash Saturn)
