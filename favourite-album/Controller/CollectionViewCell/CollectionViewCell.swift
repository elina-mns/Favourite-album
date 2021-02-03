//
//  CollectionViewCell.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 2.0 : 0
        }
    }
    
    static let identifier = "AlbumCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.blue.cgColor
    }

    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
    }

}
