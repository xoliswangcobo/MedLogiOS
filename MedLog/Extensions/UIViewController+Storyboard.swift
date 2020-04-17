//
//  Storyboards.swift
//  Lokto
//
//  Created by Altus Boneschans on 2019/11/14.
//  Copyright © 2019 Lokto. All rights reserved.
//

import UIKit

enum Storyboard : String {
    
    case Main, Home, Buy, Sell, Limits, Orders, Wallets, AddWallet, Profile, FAQ, ResetPassword, Register,
        InfoWebPage, SelectCountry, Misc
    
    func instance() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func initialViewController() -> UIViewController? {
        return instance().instantiateInitialViewController()
    }
    
    func instantiateViewController <T: UIViewController> (viewControllerClass : T.Type,
                                                          storyboardID: String? = nil) -> T {
        let id = storyboardID ?? viewControllerClass.storyboardID
        guard let scene = instance().instantiateViewController(withIdentifier: id) as? T else {
            fatalError("ViewController with identifier \(id), not found in \(self.rawValue) Storyboard.\nCalled from: \(#file)  : \(#function) : \(#line)")
        }
        
        return scene
    }
    
}

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func initialize(from storyboard: Storyboard) -> Self {
        return storyboard.instantiateViewController(viewControllerClass: self)
    }
    
}
