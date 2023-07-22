//
//  FlexibleView.swift
//  Infuzamed
//
//  Created by Vazgen on 7/12/23.
//

import Foundation
import UIKit

class FlexibleView: UIView {
    // MARK: - Properties

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            layer.cornerRadius
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            layer.shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            layer.shadowOffset
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            UIColor(cgColor: layer.borderColor!)
        }
    }

    @IBInspectable var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        get {
            UIColor(cgColor: layer.shadowColor!)
        }
    }

    @IBInspectable var circle: Bool = false {
        didSet {
            calculateCircle()
        }
    }

    // MARK: - Overide

    override func layoutSubviews() {
        super.layoutSubviews()
        calculateCircle()
    }

    private func calculateCircle() {
        if circle {
            let corner = min(bounds.size.width, bounds.size.height) / 2
            cornerRadius = corner
        }
    }
}
