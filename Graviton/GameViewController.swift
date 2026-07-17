//
//  GameViewController.swift
//  GRAVITON: Solar Conquest
//
//  Full-screen WKWebView host for the bundled canvas game.
//

import UIKit
import WebKit

final class GameViewController: UIViewController {

    private var webView: WKWebView!

    // The game's --void colour (#03030c) as a UIColor.
    private static let voidColor = UIColor(red: 0.012, green: 0.012, blue: 0.047, alpha: 1)

    override func loadView() {
        let config = WKWebViewConfiguration()
        // Let the game play sound / any inline media without a user gesture
        // (roadmap: Web Audio SFX) and keep it inline rather than fullscreen-native.
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = Self.voidColor
        webView.isOpaque = false
        webView.scrollView.backgroundColor = Self.voidColor

        // A game canvas must not scroll, bounce, or zoom under the touch handlers.
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.bouncesZoom = false
        webView.scrollView.maximumZoomScale = 1
        webView.scrollView.minimumZoomScale = 1
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        // Fill the screen edge-to-edge, under the notch/home indicator.
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Self.voidColor
        loadGame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Keep the screen on during play — no idle dimming mid-orbit.
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func loadGame() {
        guard let url = Bundle.main.url(forResource: "graviton-v5", withExtension: "html") else {
            assertionFailure("graviton-v5.html is missing from the app bundle — check Copy Bundle Resources.")
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }

    // Full-screen game chrome.
    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }

    // Supported orientations are declared in Info.plist; the canvas auto-sizes.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
    }
}
