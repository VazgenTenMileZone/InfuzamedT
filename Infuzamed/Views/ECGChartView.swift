//
//  ECGChartView.swift
//  Infuzamed
//
//  Created by Vazgen on 8/12/23.
//

import Foundation
import UIKit

class ECGChartView: UIView {
    
    private var points: [CGPoint] = []
    private var animationTimer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        setupAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation()
    }
    
    private func setupAnimation() {
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(addDataPoint), userInfo: nil, repeats: true)
    }
    
    @objc private func addDataPoint() {
        let maxValue: CGFloat = frame.height * 0.4
        let xOffset = CGFloat(points.count) * 2.0
        
        let y = maxValue * CGFloat(sin(Double(points.count) * 0.1))
        let point = CGPoint(x: xOffset, y: y)
        
        points.append(point)
        
        if xOffset > frame.width {
            points.removeFirst()
        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(2.0)
        
        context.beginPath()
        
        for (index, point) in points.enumerated() {
            if index == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        
        context.strokePath()
    }
}
