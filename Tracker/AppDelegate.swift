//
//  AppDelegate.swift
//  Tracker
//
//  Created by Mike Somov on 25.03.2025.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabBarViewController = TabBarViewController()
        window = UIWindow()
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func saveContext () {
        CoreDataManager.shared.saveContext()
    }
}
