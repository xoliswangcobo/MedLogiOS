//
//  LaunchViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            let loginNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            
            let service:NetworkServiceProtocol = ServiceHTTPAPIRequest.init(serviceHost: URL.baseURL)
            let repository:Repository = Repository.init(service: service)
            
            let loginViewController = loginNavigationController.topViewController as! LoginViewController
            loginViewController.viewModel = LoginViewModel.init(repository: repository)
            
            UIApplication.setRootView(loginNavigationController, options: .transitionCrossDissolve)
        }
    }
}
