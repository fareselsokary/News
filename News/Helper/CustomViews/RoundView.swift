//
//  RoungView.swift
//  Tsahil
//
//  Created by fares elsokary on 10/16/18.
//  Copyright © 2018 elryad. All rights reserved.
//

import UIKit
@IBDesignable
class RoundView: UIView {
    @IBInspectable var CornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = CornerRadius
        }
    }

    @IBInspectable var BorderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = BorderWidth
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

    @IBInspectable public var color1: UIColor? {
        didSet {
            updateColors()
        }
    }

    @IBInspectable public var color2: UIColor? {
        didSet {
            updateColors()
        }
    }

    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    private var gradient: CAGradientLayer?

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        gradient = createGradient()
        updateColors()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        gradient = createGradient()
        updateColors()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradient?.frame = bounds
    }

    private func updateColors() {
        guard
            let color1 = color1,
            let color2 = color2
        else {
            return
        }

        gradient?.colors = [color1.cgColor, color2.cgColor]
    }
}
