//
//  CircularProgressView.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

//@IBDesignable
class CircularProgressView: UIView, CAAnimationDelegate {
    
    private let trackLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    
    @IBInspectable var borderColor:UIColor
    @IBInspectable var borderWidth:CGFloat
    @IBInspectable var progressColor:UIColor
    @IBInspectable var progressWidth:CGFloat
    @IBInspectable var fillColor:UIColor
    @IBInspectable var startAngle:CGFloat
    @IBInspectable var endAngle:CGFloat
    @IBInspectable var clockwise:Bool
    
    private var animationEndHandler:((Timer, Bool) -> (Void))?
    private var animating:Bool = false
    private var animationTimer:Timer?
    private var updateAtInterval:CGFloat?
    
    override init(frame: CGRect) {
        self.borderColor = .white
        self.borderWidth = 0
        self.progressColor = .black
        self.progressWidth = 2
        self.fillColor = .black
        self.startAngle = -CGFloat.pi/2
        self.endAngle = 2 * CGFloat.pi - CGFloat.pi/2
        self.clockwise = true
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.borderColor = .white
        self.borderWidth = 0
        self.progressColor = .black
        self.progressWidth = 2
        self.fillColor = .black
        self.startAngle = -CGFloat.pi/2
        self.endAngle = 2 * CGFloat.pi - CGFloat.pi/2
        self.clockwise = true
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // This is circular
        self.layer.cornerRadius = self.frame.height/2
        
        // Basics
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.shapeLayer.fillColor = self.fillColor.cgColor
        
        // BezierPath
        let circularProgress = UIBezierPath(arcCenter: CGPoint(x: self.frame.height/2, y: self.frame.height/2), radius: self.frame.height/2, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: self.clockwise)
        
        trackLayer.path = circularProgress.cgPath
        trackLayer.lineWidth = self.progressWidth
        trackLayer.strokeColor = self.progressColor.cgColor
        trackLayer.fillColor = self.fillColor.cgColor
        
        self.shapeLayer.path = circularProgress.cgPath
        self.shapeLayer.lineWidth = self.progressWidth
        self.shapeLayer.strokeColor = self.progressColor.cgColor
        self.shapeLayer.strokeEnd = 0
        self.shapeLayer.lineCap = .round
        
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.shapeLayer)
    }
    
    @objc func animate(duration:CGFloat, updateAtInterval:CGFloat, handler: ((_ duration:CGFloat, _ finished:Bool) -> (Void))? = nil) {
        guard updateAtInterval <= duration else {
            if handler != nil {
                handler!(0, true)
            }
            return
        }
        
        self.updateAtInterval = updateAtInterval
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        self.animationEndHandler = { timer, finished in
            if handler != nil {
                self.animationTimer?.invalidate()
                handler!(CGFloat(timer.fireDate.timeIntervalSinceNow), finished)
                
                if finished == true {
                    self.animationTimer = nil
                }
            }
        }
        
        animation.delegate = self
        self.shapeLayer.add(animation, forKey: "strokeAnimation")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.animating = true
        self.animationTimer?.invalidate()
        
        // Animation Timer
        self.animationTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.updateAtInterval!), repeats: true) { timer in
            if self.animationEndHandler != nil {
                self.animationEndHandler!(timer, false)
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animating = false
        
        if flag == true {
            if self.animationEndHandler != nil {
                self.animationEndHandler!(self.animationTimer!, flag)
            }
        }
    }
    
    func isAnimating() -> Bool {
        return self.animating
    }
}
