//
//  UIControl+ClosureAction.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/25919472/adding-a-closure-as-target-to-a-uibutton

@objc private class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
        super.init()
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    
    func addAction(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        let sleeve = ClosureSleeve(action)
        self.removeTarget(self.allTargets.first, action: #selector(ClosureSleeve.invoke), for: control)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: control)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
