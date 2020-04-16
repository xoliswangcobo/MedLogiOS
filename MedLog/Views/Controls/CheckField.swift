//
//  CheckField.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class CheckField: UIView {

    @IBInspectable var checkWidth: CGFloat = 3
    @IBInspectable var borderWidth: CGFloat = 3
    @IBInspectable var checkColor: UIColor = .black
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var borderColor: UIColor = .white
    
    private var checkMarkLayer: CAShapeLayer?
    private var checkBoxChecked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = .clear
        self.setChecked(checked: false)
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        
        self.setChecked(checked: self.checkBoxChecked)
    }
    
    func isChecked() -> Bool {
        return self.checkBoxChecked
    }
    
    func setChecked(checked:Bool) {
        self.checkBoxChecked = checked
        
        if (checked == true) {
            self.backgroundColor = .clear
            self.drawCheckMark(frame: self.frame)
        } else {
            self.backgroundColor = .clear
            self.removeCheckMark()
        }
    }
    
    // MARK - ACTIONS
    
    @objc func didTapCheckBox(recognizer: UITapGestureRecognizer) {
        if (recognizer.state == .ended) {
            self.checkBoxChecked = !self.checkBoxChecked
            self.setChecked(checked: self.checkBoxChecked)
        }
    }
    
    /** Draws the check mark when the checkbox is set to On.
     */
    func drawCheckMark(frame:CGRect) {
        self.checkMarkLayer?.removeFromSuperlayer()
        self.checkMarkLayer = CAShapeLayer.init()
        self.checkMarkLayer?.frame = self.bounds
        self.checkMarkLayer?.path = self.pathForCheckMarkWithSize(size: self.bounds.size.height).cgPath
        
        self.checkMarkLayer?.fillColor = self.fillColor.cgColor
        self.checkMarkLayer?.strokeColor = self.checkColor.cgColor
        self.checkMarkLayer?.lineWidth = self.checkWidth
        self.checkMarkLayer?.borderColor = self.borderColor.cgColor
        self.checkMarkLayer?.borderWidth = self.borderWidth
        
        self.layer.addSublayer(self.checkMarkLayer!)
    }
    
    func pathForCheckMarkWithSize(size:CGFloat) -> UIBezierPath {
        let checkMarkPath:UIBezierPath = UIBezierPath()
        
        checkMarkPath.move(to:CGPoint(x: size*0.2, y: size*0.5))
        checkMarkPath.addLine(to:CGPoint(x: size*0.35, y: size*0.7))
        checkMarkPath.addLine(to:CGPoint(x: size*0.8, y: size*0.3))
        
        return checkMarkPath
    }
    
    /** Draws the check mark when the checkbox is set to Off.
     */
    func removeCheckMark() {
        self.checkMarkLayer?.removeFromSuperlayer()
        self.checkMarkLayer = nil
    }
}
