//
//  BaseViewController.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/14.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet public var scrollView: UIScrollView?
    var dimissKeyBoardTapGesture:UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.scrollView != nil) {
            self.scrollView?.showsVerticalScrollIndicator = false
        }
        
        // Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let customBackButton = UIBarButtonItem(title: "", style: .plain, target: navigationItem.backBarButtonItem?.target, action: navigationItem.backBarButtonItem?.action)
        navigationItem.backBarButtonItem = customBackButton
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

// MARK: - KeyBoard Notification

    @objc func keyboardWillShow(notification:Notification) {
        if let scrollView = self.scrollView {
            let info = notification.userInfo
            let rect = info?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let kbSize:CGSize = rect.size

            let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        
        for gestureRecognizer in self.view?.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(gestureRecognizer)
        }
        
        self.dimissKeyBoardTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(self.dimissKeyBoardTapGesture!)
    }

    @objc func keyboardWillHide(notification:Notification) {
        if let scrollView = self.scrollView {
            let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        
        for gestureRecognizer in self.view?.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(gestureRecognizer)
        }
        
        if self.dimissKeyBoardTapGesture != nil {
            self.dimissKeyBoardTapGesture = nil
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

