//
//  AppDelegate.swift
//  MessangerApp
//
//  Created by andy on 27.10.2021.
//

import Firebase
import Swinject
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal lazy var resolver = Assembler.sharedAssembler.resolver

    var window: UIWindow?

    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureAppearance()

        window = UIWindow()

        appCoordinator = AppCoordinator(
            router: resolver.resolve(RouterFactoryProtocol.self)!.makeWindowRootRouter(window: window!),
            resolver: resolver
        )

        appCoordinator.present(animated: true, onDismissed: nil)

        return true
    }

    func configureAppearance() {
        let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)

        UISearchBar.appearance().tintColor = candyGreen
        UINavigationBar.appearance().tintColor = candyGreen
    }

    func restartApp() {
        appCoordinator = nil
        window = nil

        window = UIWindow()
        appCoordinator = AppCoordinator(
            router: resolver.resolve(RouterFactoryProtocol.self)!.makeWindowRootRouter(window: window!),
            resolver: resolver
        )

        appCoordinator.present(animated: true, onDismissed: nil)
    }
}
