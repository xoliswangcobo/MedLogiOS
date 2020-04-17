//
//  UIImage+Emoji.swift
//  MedLog
//
//  Created by Xoliswa on 2020/04/17.
//  Copyright © 2020 NativeByte. All rights reserved.
//

import UIKit

extension String {
    func image(size:CGSize) -> UIImage? {
        let size = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.width)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
