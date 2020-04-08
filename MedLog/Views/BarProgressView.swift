//
//  BarProgressView.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

//@IBDesignable
class BarProgressView: UIView, CAAnimationDelegate {
    
    let height:CGFloat = 3.0
    
    private let trackLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    
    @IBInspectable var borderColor:UIColor
    @IBInspectable var borderWidth:CGFloat
    @IBInspectable var progressColor:UIColor
    @IBInspectable var progressWidth:CGFloat
    @IBInspectable var fillColor:UIColor
    @IBInspectable var forward:Bool
    
    private var animationEndHandler:((Bool) -> (Void))?
    private var animationTimer:Timer?
    
    var updateAtInterval:CGFloat = 0.0
    
    override init(frame: CGRect) {
        self.borderColor = .white
        self.borderWidth = 0
        self.progressColor = .black
        self.progressWidth = 2
        self.fillColor = .black
        self.forward = true
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.borderColor = .white
        self.borderWidth = 0
        self.progressColor = .black
        self.progressWidth = 2
        self.fillColor = .black
        self.forward = true
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // Basics
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.shapeLayer.fillColor = self.fillColor.cgColor
        
        // BezierPath Line
        let barProgress = UIBezierPath()
        barProgress.move(to:CGPoint(x: 1, y: self.height/2))
        barProgress.addLine(to:CGPoint(x: rect.size.width, y: self.height/2))
        
        trackLayer.path = barProgress.cgPath
        trackLayer.lineWidth = self.height
        trackLayer.strokeColor = self.progressColor.cgColor
        trackLayer.fillColor = self.fillColor.cgColor
        
        self.shapeLayer.path = barProgress.cgPath
        self.shapeLayer.lineWidth = self.height
        self.shapeLayer.strokeColor = self.progressColor.cgColor
        self.shapeLayer.strokeEnd = 0
        self.shapeLayer.lineCap = .round
        
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.shapeLayer)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: self.height)
    }
    
    func animate(duration:CGFloat, repeats:Bool = true, updateAtInterval:CGFloat = 0.0, handler: ((_ finished:Bool) -> (Void))? = nil) {
        guard updateAtInterval <= duration else {
            handler?(true)
            
            return
        }
        
        self.updateAtInterval = updateAtInterval
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        self.animationEndHandler = { finished in
            handler?(finished)
            
            if finished == true {
                self.animationTimer = nil
                
                if repeats == true {
                    self.animate(duration: duration, updateAtInterval: updateAtInterval, handler: handler)
                } else {
                    self.stopAnimation()
                }
            }
        }
        
        animation.delegate = self
        self.shapeLayer.add(animation, forKey: "strokeAnimation")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.animationTimer?.invalidate()
        
        // Animation Timer
        if self.updateAtInterval > 0.0 {
            self.animationTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.updateAtInterval), repeats: true) { timer in
                self.animationEndHandler?(false)
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            self.animationEndHandler?(flag)
        }
    }
    
    func stopAnimation() {
        self.animationTimer?.invalidate()
        self.animationTimer = nil
        self.animationEndHandler = nil
        
        self.shapeLayer.removeAllAnimations()
    }
    
    func isAnimating() -> Bool {
        return self.animationTimer?.isValid ?? false
    }
}
