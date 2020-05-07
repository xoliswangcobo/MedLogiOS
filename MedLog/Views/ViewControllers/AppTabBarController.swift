//
//  AppTabBarController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/16.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {

    var repository:Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutApp))
    }

    @objc private func logoutApp() {
        self.repository.logout { (error) in
            self.repository.servive.authenticationToken = nil
            let navigationController = Storyboard.Startup.instantiateViewController(viewControllerClass: UINavigationController.self, storyboardID: "LoginNavigationController")
            
            UIApplication.setRootView(navigationController, options: UIApplication.logoutAnimation, animated: false)
        }
    }
}
