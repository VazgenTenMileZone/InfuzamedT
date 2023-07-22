//
//  PipesView.swift
//  Infuzamed
//
//  Created by Vazgen on 7/17/23.
//

import Foundation
import UIKit

class PipesView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var valueStackView: UIStackView!
    @IBOutlet var backgroundTopView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var frontView: UIView!
    @IBOutlet var frontTopView: UIView!
    @IBOutlet var currentValueLabel: UILabel!
    @IBOutlet var frontViewHeight: NSLayoutConstraint!
    public var colors: [UIColor] = []
    private var gradientLayer: CAGradientLayer!
    private var minValue = 0
    private var maxValue = 100
    private var currentValue = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func configView(currentV: Int, minV: Int, maxV: Int, colors: [UIColor]) {
        self.colors = colors
        currentValue = currentV
        minValue = minV
        maxValue = maxV
        calculateLeftStackViews()
        caluclateFrontViewHeight()
        currentValueLabel.text = "\(currentV)"
        calculateGradient()
    }
}

private extension PipesView {
    func setupViews() {
        Bundle.main.loadNibNamed("PipesView", owner: self)
        addSubview(contentView)
        let angleInRadians = 2 * CGFloat.pi - 0.2
        currentValueLabel.transform = CGAffineTransform(rotationAngle: angleInRadians)
        contentView.pinEdgesToSuperView()
        updateLocalConstraints()
    }
    
    func calculateGradient() {
        layoutIfNeeded()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frontView.bounds
        if let first = colors.first {
            gradientLayer.colors = [first.cgColor]
        }
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let percent = currentValue * 100 / maxValue
        
        switch percent {
        case 0...25:
            if colors.count > 1 {
                gradientLayer.colors?.insert(colors[1].cgColor, at: 0)
            }
        case 26...50:
            if colors.count > 1 {
                gradientLayer.colors?.insert(colors[1].cgColor, at: 0)
            }
            if colors.count > 2 {
                gradientLayer.colors?.insert(colors[2].cgColor, at: 0)
            }
        case 51...75:
            if colors.count > 1 {
                gradientLayer.colors?.insert(colors[1].cgColor, at: 0)
            }
            if colors.count > 2 {
                gradientLayer.colors?.insert(colors[2].cgColor, at: 0)
            }
            if colors.count > 3 {
                gradientLayer.colors?.insert(colors[3].cgColor, at: 0)
            }
        default:
            if colors.count > 1 {
                gradientLayer.colors?.insert(colors[1].cgColor, at: 0)
            }
            if colors.count > 2 {
                gradientLayer.colors?.insert(colors[2].cgColor, at: 0)
            }
            if colors.count > 3 {
                gradientLayer.colors?.insert(colors[3].cgColor, at: 0)
            }
            if colors.count > 4 {
                gradientLayer.colors?.insert(colors[4].cgColor, at: 0)
            }
            
        }

        if let last = colors.last {
            frontTopView.backgroundColor = last.darken(by: 0.1)
        }
        frontView.layer.addSublayer(gradientLayer)
        updateLocalConstraints()
    }
    
    func calculateLeftStackViews() {
        var maxPoint = maxValue
        while maxPoint >= minValue {
            valueStackView.addArrangedSubview(generateSubStaks(value: maxPoint))
            maxPoint -= 10
        }
    }
    
    func caluclateFrontViewHeight() {
        let staksCount = CGFloat((maxValue - minValue) / 10 + 1)
        let multipleValue = CGFloat((currentValue - minValue) / 10 + 1)
        let heightOneStak = valueStackView.bounds.height / staksCount
        frontViewHeight.constant = multipleValue * heightOneStak
    }
    
    func generateSubStaks(value: Int) -> UIStackView {
        // Create a UILabel
        let label = UILabel()
        label.text = String(value)
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
         
        // Create an indicator UIView
        let indicatorView = UIView()
        indicatorView.backgroundColor = UIColor(hex: "E6E6E6")
         
        // Create a horizontal UIStackView
        let stackView = UIStackView(arrangedSubviews: [label, indicatorView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.distribution = .fillEqually
         
        // Set the height constraint for the indicator view (1 point height)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        return stackView
    }
    
    
    func updateLocalConstraints() {
        frontView.roundCorners(corners: .allCorners, radius: 25)
        backgroundView.layer.cornerRadius = 25
        backgroundTopView.layer.cornerRadius = 20
        frontTopView.layer.cornerRadius = 20
    }
}
