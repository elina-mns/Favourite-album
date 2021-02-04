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
    
    var savedAlbum: [AlbumDataModel] = []
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
    }
    
    //MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        savedAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as?
                CollectionViewCell else { fatalError() }
        let item = savedAlbum[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedIndex == indexPath {
            selectedIndex = nil
            
        } else {
            selectedIndex = indexPath
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            performSegue(withIdentifier: "showThirdVC", sender: self)
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThirdVC {
            vc.album = savedAlbum.first
        }
    }
    

}

