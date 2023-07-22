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
        imageView.image = UIImage(named: item.rawValue)
    }
}
