//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Mike Somov on 27.03.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    // MARK: - Private methods
    
    private func configureTabs() {
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.title = "Трекеры"
        statisticViewController.title = "Статистика"
        
        trackerViewController.tabBarItem.image = UIImage(systemName: "record.circle")
        statisticViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticNavigationController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([trackerNavigationController, statisticNavigationController], animated: true)
    }
}
