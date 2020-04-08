//
//  UIView+Transition.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//
//  https://stackoverflow.com/questions/3073520/animate-text-change-in-uilabel
//

import UIKit

extension UIView {
    
    enum TransitionType: String {
        case TransitionFade = "fade"
        case TransitionMoveIn = "moveIn"
        case TransitionPush = "push"
        case TransitionReveal = "reveal"
        case TransitionCameraIris = "cameraIris"
        case TransitionCameraIrisHollowOpen = "cameraIrisHollowOpen"
        case TransitionCameraIrisHollowClose = "cameraIrisHollowClose"
        case TransitionCube = "cube"
        case TransitionAlignedCube = "alignedCube"
        case TransitionFlip = "flip"
        case TransitionAlignedFlip = "alignedFlip"
        case TransitionOglFlip = "oglFlip"
        case TransitionRotate = "rotate"
        case TransitionPageCurl = "pageCurl"
        case TransitionPageUnCurl = "pageUnCurl"
        case TransitionRippleEffect = "rippleEffect"
        case TransitionSuckEffect = "suckEffect"
        case TransitionFromRight = ""
        case TransitionSpewEffect = "spewEffect"
        case TransitionGenieEffect = "genieEffect"
        case TransitionUnGenieEffect = "unGenieEffect"
        case TransitionTwist = "twist"
        case TransitionTubey = "tubey"
        case TransitionSwirl = "swirl"
        case TransitionCharminUltra = "charminUltra"
        case TransitionZoomyIn = "zoomyIn"
        case TransitionZoomyOut = "zoomyOut"
    }
    
    func transition(duration:CFTimeInterval, type:TransitionType) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .init(rawValue: type.rawValue)
        animation.duration = duration
        layer.add(animation, forKey: type.rawValue)
    }
}
