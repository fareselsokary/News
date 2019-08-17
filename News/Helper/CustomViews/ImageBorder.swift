//
//  ImageBorder.swift
//  Doctor booking
//
//  Created by fares elsokary on 10/8/18.
//  Copyright © 2018 FaresElsokary. All rights reserved.
//

import UIKit
@IBDesignable
class ImageBorder: UIImageView {
    @IBInspectable var CornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = CornerRadius
        }
    }

    @IBInspectable var BorderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = BorderWidth
           // clipsToBounds = true
        }
    }

    @IBInspectable var BorderColer: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = BorderColer.cgColor
        }
    }

    @IBInspectable internal var shadow_Color: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadow_Color.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRaduis: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRaduis
        }
    }
    
    @IBInspectable var shadowOffset: CGFloat = 0.0 {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        }
    }
}
