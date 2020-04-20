//
//  AppDelegate.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set Navigation/TabBar attributes
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .primary
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().unselectedItemTintColor = .tertiary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary, NSAttributedString.Key.font: UIFont.extraLarge]
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ABeeZee-Regular", size: 11)!], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ABeeZee-Regular", size: 11) as Any], for: .selected)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ABeeZee-Regular", size: 17)!], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ABeeZee-Regular", size: 17) as Any], for: .selected)
        
        return true
    }


}

