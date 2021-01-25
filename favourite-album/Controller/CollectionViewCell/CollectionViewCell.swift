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
    
    static let identifier = "AlbumCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}