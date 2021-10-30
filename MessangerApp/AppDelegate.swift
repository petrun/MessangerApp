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

    fileprivate var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        window = UIWindow()

        appCoordinator = AppCoordinator(
            router: resolver.resolve(RouterFactoryProtocol.self)!.makeWindowRootRouter(window: window!),
            resolver: resolver
        )

        appCoordinator.present(animated: true, onDismissed: nil)

        return true
    }
}
