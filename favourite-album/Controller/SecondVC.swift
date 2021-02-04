//
//  SecondVC.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit
import CoreData

class SecondVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex: IndexPath?
    var fetchedResultsController: NSFetchedResultsController<AlbumDataModel>!
    private var fabButton = UIButton(type: .custom)
    private var secondFabButton = UIButton(type: .custom)
    
    var persistentContainer: NSPersistentContainer {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        setupFetchedResultsController()
        configureFloatingActionButton()
        configureSecondFloatingActionButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
    }
    
    //MARK: - Setup Fetched Results Controller
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<AlbumDataModel> = AlbumDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Album")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be executed: \(error.localizedDescription)")
        }
    }
        
    
    //MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as?
                CollectionViewCell else { fatalError() }
        let item = fetchedResultsController.object(at: indexPath)
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
        }
        return false
    }
    
    //MARK: - Transfer information to the Third View and request info
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThirdVC,
           let index = selectedIndex {
            vc.album = fetchedResultsController.object(at: index)
        }
    }
        
    //MARK: - Floating Action Buttons and actions: Delete and Info
    
    private func configureFloatingActionButton() {
        fabButton.frame = CGRect(x: 280, y: 700, width: 70, height: 70)
        fabButton.backgroundColor = .purple
        fabButton.clipsToBounds = true
        fabButton.layer.cornerRadius = 20
        fabButton.layer.borderWidth = 3.0
        fabButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        fabButton.tintColor = .white
        fabButton.setTitle("Delete", for: .normal)
        view.addSubview(fabButton)
    }
    
    private func configureSecondFloatingActionButton() {
        secondFabButton.frame = CGRect(x: 40, y: 700, width: 70, height: 70)
        secondFabButton.backgroundColor = .purple
        secondFabButton.clipsToBounds = true
        secondFabButton.layer.cornerRadius = 20
        secondFabButton.layer.borderWidth = 3.0
        secondFabButton.tintColor = .white
        secondFabButton.setTitle("Info", for: .normal)
        secondFabButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        view.addSubview(secondFabButton)
    }
    
    
    @objc
    func deleteTapped() {
        if let index = selectedIndex {
            persistentContainer.viewContext.delete(fetchedResultsController.object(at: index))
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            doNothing()
        }
    }
    
    func doNothing() {
    }
    
    @objc
    func infoTapped() {
        performSegue(withIdentifier: "showThirdVC", sender: self)
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
         case .delete:
            guard let indexPath = indexPath else { return }
            collectionView.deleteItems(at: [indexPath])
         default:
             break
         }
    }
}

