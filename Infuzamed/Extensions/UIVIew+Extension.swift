//
//  UIVIew+Extension.swift
//  Infuzamed
//
//  Created by Vazgen on 7/17/23.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat = 7) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.backgroundColor = UIColor.clear.cgColor
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func pinEdgesToSuperView(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right)
        ])
    }
}
