//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Mike Somov on 25.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = showOnboarding()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func showOnboarding() -> UIViewController {
        var rootViewController = UIViewController()
        if UserDefaults.isFirstLaunch() {
            rootViewController = OnboardingPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
        } else {
            rootViewController = TabBarViewController()
        }
        return rootViewController
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}
