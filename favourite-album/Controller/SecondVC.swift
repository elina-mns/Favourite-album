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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    //MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FirstVC().savedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouriteAlbum", for: indexPath)
        let album = FirstVC().savedItems[indexPath.row]
        cell.albumLabel.text = album.value(forKeyPath: "name") as? String
        cell.albumImageView.image = album.value(forKeyPath: "imageURL") as? String
        return cell
    }
    

}
