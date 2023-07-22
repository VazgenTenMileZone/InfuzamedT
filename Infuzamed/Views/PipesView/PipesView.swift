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
        
        if let firstColor = colors.first {
            gradientLayer.colors = [firstColor.cgColor]
        }
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let percent = (currentValue - minValue) * 100 / (maxValue - minValue)
        let roundedValue = Double(percent / 25).rounded(.down)
        
        for i in 1...min(colors.count - 1, Int(roundedValue)) {
            gradientLayer.colors?.insert(colors[i].cgColor, at: 0)
        }
        
        if let lastCgColor = gradientLayer.colors?.first {
            frontTopView.backgroundColor = UIColor(cgColor: lastCgColor as! CGColor).darken(by: 0.1)
        }
        
        frontView.layer.addSublayer(gradientLayer)
        updateLocalConstraints()
    }
    
    func setStakLabelColor(value: Int) -> UIColor {
        let percent = (value - minValue) * 100 / (maxValue - minValue)
        let colorCount = colors.count

        if colorCount == 0 {
            return .red
        } else if colorCount == 1 {
            return colors[0]
        }

        // Calculate the index of the color based on the percentage value
        let roundedValue = Double(percent / 25).rounded(.down)
        let index = min(colorCount - 1, Int(roundedValue))

        return colors[index]
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
        label.textColor = setStakLabelColor(value: value)
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
