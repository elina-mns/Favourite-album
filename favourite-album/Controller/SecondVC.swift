//
//  SecondVC.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit

class SecondVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let items = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    

}
