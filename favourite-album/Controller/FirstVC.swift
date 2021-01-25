//
//  ViewController.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit

class FirstVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var searchItems: [Album] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollection: UICollectionView!
    private var fabButton = UIButton(type: .custom)
    private var secondFabButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollection.delegate = self
        searchCollection.dataSource = self
        searchBar.delegate = self
        searchCollection.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        // add action on "return" of keyvboard to trigger api call for search
        logoView.image = UIImage(named: "defaultIcon")
        configureFloatingActionButton()
        configureSecondFloatingActionButton()
        
        AlbumSearchAPI().requestSearchAlbums(searchQuery: "black") { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response {
                self.searchItems = response.results.albummatches.album
                DispatchQueue.main.async {
                    self.searchCollection.reloadData()
                }
            }
        }
    }
        
    
    //MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        let item = searchItems[indexPath.row]
        cell.albumLabel.text = item.name
        
        cell.albumImageView.downloaded(from: item.getImageURL(with: .medium)!) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    cell.albumImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    cell.albumImageView.image = UIImage(named: "error")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) / 2 - 9
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    //MARK: - Floating Action Buttons
    
    private func configureFloatingActionButton() {
        fabButton.frame = CGRect(x: 280, y: 700, width: 70, height: 70)
        fabButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        fabButton.clipsToBounds = true
        fabButton.layer.cornerRadius = 20
        fabButton.layer.borderWidth = 3.0
        fabButton.addTarget(self, action: #selector(showSecondVC), for: .touchUpInside)
        fabButton.tintColor = .white
        fabButton.setTitle("Saved", for: .normal)
        view.addSubview(fabButton)
    }
    
    private func configureSecondFloatingActionButton() {
        secondFabButton.frame = CGRect(x: 40, y: 700, width: 70, height: 70)
        secondFabButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        secondFabButton.clipsToBounds = true
        secondFabButton.layer.cornerRadius = 20
        secondFabButton.layer.borderWidth = 3.0
        secondFabButton.tintColor = .white
        secondFabButton.setTitle("+", for: .normal)
        secondFabButton.titleLabel?.font = .systemFont(ofSize: 40)
        view.addSubview(secondFabButton)
    }
    
    
    @objc
    func showSecondVC() {
        performSegue(withIdentifier: "showSecondVC", sender: self)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: "reload", object: nil)
        self.perform("reload", with: nil, afterDelay: 0.5)
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
