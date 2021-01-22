//
//  ViewController.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit

class FirstVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items: [SearchResponseModel] = []
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollection.delegate = self
        searchCollection.dataSource = self
        logoView.image = UIImage(named: "defaultIcon")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return cell
    }
    

}



//MARK: - Extension for UIImageView to process the link in JSON

extension UIImageView {
    
    func downloaded(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                completion?(nil)
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(image)
            }
        }.resume()
    }
}
