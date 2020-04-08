//
//  ArrowButton.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

enum ArrowDirection: String {
    case left, up, right, down
}

class ArrowButton: UIButton {
    
    @IBInspectable var arrowWidth:CGFloat = 2 {
        didSet {
            drawArrow()
        }
    }
    
    @IBInspectable var arrowColor:UIColor = .black {
        didSet {
            self.drawArrow()
        }
    }
    
    @IBInspectable var arrowFillColor:UIColor = .white {
        didSet {
            self.drawArrow()
        }
    }
    
    @IBInspectable var arrowBorderColor:UIColor = .white {
        didSet {
            self.drawArrow()
        }
    }
    
    @IBInspectable var ibArrowDirection: String {
        get {
            arrowDirection.rawValue
        }
        set {
            arrowDirection = ArrowDirection.init(rawValue: newValue.lowercased()) ?? .left
        }
    }
    var arrowDirection: ArrowDirection = .left {
        didSet {
            self.drawArrow()
        }
    }
    
    private var arrowLayer:CAShapeLayer?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawArrow()
    }
    
    // MARK: Fileprivate drawing implementation
    
    fileprivate func drawArrow() {
        self.arrowLayer?.removeFromSuperlayer()
        
        self.arrowLayer = CAShapeLayer.init()
        self.arrowLayer?.frame = self.bounds
        self.arrowLayer?.path = self.pathForArrowWithSize(size: self.frame.size).cgPath
        self.arrowLayer?.fillColor = self.arrowFillColor.cgColor
        self.arrowLayer?.strokeColor = self.arrowColor.cgColor
        self.arrowLayer?.lineWidth = self.arrowWidth
        self.arrowLayer?.borderColor = self.arrowBorderColor.cgColor
        self.arrowLayer?.lineCap = .round
        
        self.layer.addSublayer(self.arrowLayer!)
    }
    
    fileprivate func pathForArrowWithSize(size:CGSize) -> UIBezierPath {
        let arrowPath:UIBezierPath = UIBezierPath()
        
        switch self.arrowDirection {
            case .down:
                arrowPath.move(to:CGPoint(x: size.width*0.2, y: size.height*0.2))
                arrowPath.addLine(to:CGPoint(x: size.width*0.5, y: size.height*0.75))
                arrowPath.addLine(to:CGPoint(x: size.width*0.80, y: size.height*0.2))
            case .up:
                arrowPath.move(to:CGPoint(x:size.width*0.2, y: size.height*0.75))
                arrowPath.addLine(to:CGPoint(x: size.width*0.5, y: size.height*0.20))
                arrowPath.addLine(to:CGPoint(x: size.width*0.8, y: size.height*0.75))
            case .right:
                arrowPath.move(to:CGPoint(x: size.width*0.2, y: size.height*0.2))
                arrowPath.addLine(to:CGPoint(x: size.width*0.75, y: size.height*0.5))
                arrowPath.addLine(to:CGPoint(x: size.width*0.2, y: size.height*0.8))
            case .left:
                arrowPath.move(to:CGPoint(x: size.width*0.8, y: size.height*0.2))
                arrowPath.addLine(to:CGPoint(x: size.width*0.25, y: size.height*0.5))
                arrowPath.addLine(to:CGPoint(x: size.width*0.8, y: size.height*0.8))
        }
        
        return arrowPath
    }
}
