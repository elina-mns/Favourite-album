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
    
    var model = [SearchResponseModel]()
    
    static func nib() -> UINib {
        return UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
    }
    
    func configure(with model: [SearchResponseModel]) {
        self.model = model
        albumLabel.text = "\(Album.name)"
        albumImageView.contentMode = .scaleAspectFit
        albumImageView.image = Album.image
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
