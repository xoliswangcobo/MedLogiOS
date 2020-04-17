//
//  UIViewController+BackButton.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/15.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

enum Storyboard : String {
    
    case App, Startup
    
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
