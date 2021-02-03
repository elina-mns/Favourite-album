//
//  ViewController.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit
import CoreData

class FirstVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
        
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollection: UICollectionView!
    
    private var fabButton = UIButton(type: .custom)
    private var secondFabButton = UIButton(type: .custom)
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    let searchController = UISearchController(searchResultsController: nil)
    var searchItems: [Album] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var isLoading = false
    
    var savedItems: [AlbumDataModel] = []
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollection.delegate = self
        searchCollection.dataSource = self
        searchBar.delegate = self
        searchBar.barTintColor = .systemPurple
        searchCollection.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        searchCollection.allowsMultipleSelection = true
        logoView.image = UIImage(named: "music")
        configureFloatingActionButton()
        configureSecondFloatingActionButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchCollection.indexPathsForSelectedItems?.forEach({ (indexPath) in
            searchCollection.deselectItem(at: indexPath, animated: false)
        })
    }
    
    func searchAlbum(with name: String) {
        isLoading = true
        AlbumSearchAPI().requestSearchAlbums(searchQuery: name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") { (response, error) in
            self.isLoading = false
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
        
        cell.activityIndicator.startAnimating()
        
        if item.getImageURL(with: .large) != nil {
            cell.albumImageView.downloaded(from: item.getImageURL(with: .large)!) { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        cell.albumImageView.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.albumImageView.image = UIImage(named: "error")
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = view.frame.width / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedIndex == indexPath {
            selectedIndex = nil
            
        } else {
            selectedIndex = indexPath
            searchCollection.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
        return false
    }
    
    //MARK: - Floating Action Buttons
    
    private func configureFloatingActionButton() {
        fabButton.frame = CGRect(x: 280, y: 700, width: 70, height: 70)
        fabButton.backgroundColor = .purple
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
        secondFabButton.backgroundColor = .purple
        secondFabButton.clipsToBounds = true
        secondFabButton.layer.cornerRadius = 20
        secondFabButton.layer.borderWidth = 3.0
        secondFabButton.tintColor = .white
        secondFabButton.setTitle("+", for: .normal)
        secondFabButton.titleLabel?.font = .systemFont(ofSize: 40)
        secondFabButton.addTarget(self, action: #selector(saveAlbumsAndShowSecondVC), for: .touchUpInside)
        view.addSubview(secondFabButton)
    }
    
    
    //MARK: - Search Bar Activation
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              !text.isEmpty,
              !isLoading
        else { return }
        searchAlbum(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.tintColor = .black
    }
    
    //MARK: - Second VC actions + Save item to Favourites
    
    func saveAlbum(artist: String, imageUrl: Image, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let album = AlbumDataModel(context: managedContext)
        album.artist = artist
        album.imageURL = imageUrl.url?.path
        album.name = name
        do {
            try managedContext.save()
            savedItems.append(album)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc
    func showSecondVC() {
        performSegue(withIdentifier: "showSecondVC", sender: self)
    }
    
    @objc
    func saveAlbumsAndShowSecondVC() {
        guard let selectedIndex = selectedIndex else { return }
        let album = searchItems[selectedIndex.row]
        let artist = album.artist
        let imageURL = album.image.first
        let name = album.name
        saveAlbum(artist: artist, imageUrl: imageURL!, name: name)
        showSecondVC()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondVC {
            vc.album = savedItems
        }
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

