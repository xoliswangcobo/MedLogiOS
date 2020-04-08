//
//  SegmentedControl.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.initialConfig()
    }
    
    func initialConfig() {
        if #available(iOS 13.0, *) {
            self.setTitleTextAttributes([.foregroundColor: UIColor.lightGray ], for: .selected)
            self.setTitleTextAttributes([.foregroundColor: UIColor.yellow ], for: .normal)
            
            self.selectedSegmentTintColor = .yellow
            
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 1.4
            
            self.setBackgroundImage(self.imageWithColor(color: UIColor.yellow, width: 10, height: 10), for: .normal, barMetrics: .default)
            self.setBackgroundImage(self.imageWithColor(color: UIColor.lightGray, width: 10, height: 10), for: .selected, barMetrics: .default)
        } else {
            self.tintColor = .yellow
        }
    }
    
    private func imageWithColor(color: UIColor, width: Int, height: Int) -> UIImage {
        let size = CGSize(width: width, height: height)
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
