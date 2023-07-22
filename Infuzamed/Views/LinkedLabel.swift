//
//  LinkedLabel.swift
//  Infuzamed
//
//  Created by Vazgen on 7/19/23.
//

import Foundation
import UIKit

class LinkedLabel: UILabel {
    // MARK: - Properties
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: .zero)
    var textStorage = NSTextStorage() {
        willSet {
            newValue.addLayoutManager(layoutManager)
        }
    }

    override var attributedText: NSAttributedString? {
        willSet {
            if let attributedText = newValue {
                textStorage = NSTextStorage(attributedString: attributedText)
            } else {
                textStorage = NSTextStorage()
            }
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        willSet {
            textContainer.lineBreakMode = newValue
        }
    }

    override var numberOfLines: Int {
        willSet {
            textContainer.maximumNumberOfLines = newValue
        }
    }

    private var localizableText: String?
    override var text: String? {
        didSet {
            localizableText = text
            updateText()
        }
    }

    var linkedTexts: [(text: String, attributes: [NSAttributedString.Key: Any], action: () -> Void)] = [] {
        didSet {
            updateText()
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        startup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        startup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Startup
private extension LinkedLabel {
    func startup() {
        addRecognizers()

        numberOfLines = 0
        isUserInteractionEnabled = true

        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines

        updateText()
    }

    func addRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
    }
}

// MARK: - Actions
private extension LinkedLabel {
    @objc func updateText() {
        let string = (localizableText ?? "")
        let attributedString = NSMutableAttributedString(string: string)

        for linkedText in linkedTexts {
            let range = (string as NSString).range(of: linkedText.text)
            attributedString.addAttributes(linkedText.attributes, range: range)
        }

        attributedText = attributedString
    }

    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended, let text = attributedText?.string as NSString? else { return }
        let locationOfTouch = sender.location(in: sender.view)
        let locationOfTouchInTextContainer = getLocationOfTap(tapLocation: locationOfTouch)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        for linkedText in linkedTexts {
            let range = text.range(of: linkedText.text)
            if range.contains(indexOfCharacter) {
                linkedText.action()
                break
            }
        }
    }

    func getLocationOfTap(tapLocation: CGPoint) -> CGPoint {
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        var alignmentOffset: CGFloat!
        switch textAlignment {
        case .left, .natural, .justified:
            alignmentOffset = 0.0
        case .center:
            alignmentOffset = 0.5
        case .right:
            alignmentOffset = 1.0
        @unknown default:
            alignmentOffset = 0.0
        }
        let xOffset = ((bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        return CGPoint(x: tapLocation.x - xOffset, y: tapLocation.y - yOffset)
    }
}
