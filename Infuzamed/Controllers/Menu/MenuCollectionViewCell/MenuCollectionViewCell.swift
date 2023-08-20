//
//  MenuCollectionViewCell.swift
//  Infuzamed
//
//  Created by Vazgen on 7/13/23.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: MenuItems) {
        let alpa = item == .bloodPressure ? 1 : 0.3
        imageView.image = UIImage(named: item.rawValue)
        imageView.alpha = alpa
    }
}
