//
//  AppDelegate.swift
//  FileManager
//
//  Created by Егор Лазарев on 05.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabBar = UITabBarController()
        let loginNavigationController = UINavigationController(rootViewController: LoginViewController())
        loginNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        settingsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        tabBar.viewControllers = [loginNavigationController, settingsNavigationController]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

