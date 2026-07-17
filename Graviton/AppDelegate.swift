//
//  AppDelegate.swift
//  GRAVITON: Solar Conquest
//
//  Native Swift/WKWebView shell that hosts the self-contained
//  graviton-v5.html canvas game. No storyboards, no scenes — a single
//  full-screen game view controller owns the whole window.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        // Match the game's void background (#03030c) so there is no flash
        // between launch and the first rendered frame.
        window.backgroundColor = UIColor(red: 0.012, green: 0.012, blue: 0.047, alpha: 1)
        window.rootViewController = GameViewController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
