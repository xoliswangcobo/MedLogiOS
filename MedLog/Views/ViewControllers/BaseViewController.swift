//
//  BaseViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let customBackButton = UIBarButtonItem(title: "", style: .plain, target: navigationItem.backBarButtonItem?.target, action: navigationItem.backBarButtonItem?.action)
        navigationItem.backBarButtonItem = customBackButton
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
}
