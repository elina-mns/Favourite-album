//
//  ThirdVC.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-02-03.
//

import UIKit

class ThirdVC: UIViewController {
    
    @IBOutlet weak var listenersAmount: UILabel!
    @IBOutlet weak var playcount: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestInfo(with name: String) {
        isLoading = true
        AlbumInfoAPI().requestInfo(searchQuery: name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            (response, error) in
                self.isLoading = false
                if let error = error {
                    print(error.localizedDescription)
                } else if let response = response {
                    DispatchQueue.main.async {
                        self.listenersAmount.text = response.listeners
                        self.playcount.text = response.playcount
                        self.infoText.text = response.wiki.summary
                    }
                }
            }
        }
    }
    
