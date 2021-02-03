//
//  SecondVC.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit
import CoreData

class SecondVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var album: [AlbumDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    //MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as?
                CollectionViewCell else { fatalError() }
        let item = album[indexPath.row]
        cell.albumLabel.text = item.artist
        cell.name.text = item.name
        if let imageUrlString = item.imageURL,
           let imageURL = URL(string: imageUrlString) {
            cell.albumImageView.downloaded(from: imageURL) { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        cell.albumImageView.image = image
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.hidesWhenStopped = true
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.albumImageView.image = UIImage(named: "error")
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.hidesWhenStopped = true
                    }
                }
            }
        }
        return cell
    }
    

}

