//
//  Container.swift
//  MedLog
//
//  Created by Xoliswa on 2020/05/06.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class AppContainer {
    
    static let shared = AppContainer()
    
    let container = Container()
    
    init() {
        self.setupContainer()
    }
    
    private func setupContainer() {
        
        container.register(Repository.self) { resolver in
            return Repository(service: resolver.resolve(NetworkServiceProtocol.self)!)
        }
        
        container.register(NetworkServiceProtocol.self) { _ in ServiceHTTPAPIRequest.init(serviceHost: URL.baseURL) }
        
        container.register(LoginViewModel.self) { resolver in
            return LoginViewModel.init(repository: resolver.resolve(Repository.self)!)
        }
        
        container.register(SignUpViewModel.self) { resolver in
            return SignUpViewModel.init(repository: resolver.resolve(Repository.self)!)
        }
        
        container.register(ForgorPasswordViewModel.self) { resolver in
            return ForgorPasswordViewModel.init(repository: resolver.resolve(Repository.self)!)
        }
    }
}

extension SwinjectStoryboard {
    @objc class func setup() {

        defaultContainer.storyboardInitCompleted(LoginViewController.self) { _, controller in
            controller.viewModel = AppContainer.shared.container.resolve(LoginViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(RegisterViewController.self) { _, controller in
            controller.viewModel = AppContainer.shared.container.resolve(SignUpViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(ForgotPasswordViewController.self) { _, controller in
            controller.viewModel = AppContainer.shared.container.resolve(ForgorPasswordViewModel.self)
        }
        
        defaultContainer.storyboardInitCompleted(AppTabBarController.self) { _, controller in
            controller.repository = AppContainer.shared.container.resolve(Repository.self)
        }        
    }
}
