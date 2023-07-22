//
//  GradientView.swift
//  Infuzamed
//
//  Created by Vazgen on 7/12/23.
//

import Foundation
import UIKit

class GradientView: FlexibleView {
    // MARK: - Properties

    var gradientLocationX = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var gradientLocationY = 0.70 {
        didSet {
            setNeedsDisplay()
        }
    }

    var gradientLocationZ = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var gradientColors: [UIColor] = [.white, UIColor(red: 254.0/255, green: 197.0/255, blue: 3.0/255, alpha: 1)] {
        didSet {
            setNeedsDisplay()
        }
    }

    var drawDirection: GradientViewDrawDirection? {
        didSet {
            setNeedsDisplay()
        }
    }

    override var isHidden: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Live Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setNeedsDisplay()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        if gradientColors.count == 0 || isHidden {
            super.draw(rect)
            return
        }
        let cgColors = gradientColors.map { $0.cgColor }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        let pointer = UnsafeMutablePointer<CGFloat>.allocate(capacity: gradientColors.count)
        pointer.initialize(repeating: 0, count: gradientColors.count)
        defer {
            pointer.deinitialize(count: gradientColors.count)
            pointer.deallocate()
        }
        if gradientColors.count == 1 {
            pointer.pointee = 1
        } else {
            for index in 0 ..< gradientColors.count {
                let value = CGFloat(index/(gradientColors.count - 1))
                pointer.advanced(by: index).pointee = value
            }
            //  1
            //  0, 1
            //  0, 0.5, 1
            //  0, 0.3, 0.6, 1
        }
        let unsafePointer = UnsafePointer(pointer)

        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: unsafePointer)
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero

        if drawDirection == .lefToRight {
            startPoint = CGPoint(x: rect.midX, y: rect.minY)
            endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        } else {
            startPoint = CGPoint(x: rect.minX, y: rect.minY)
            endPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        }
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
    }
}

enum GradientViewDrawDirection: Int {
    case topToBottom
    case lefToRight
}
