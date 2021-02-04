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
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var isLoading = false
    var album: AlbumDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let artist = album?.artist,
              let album = album?.name else { return }
        requestInfo(artist: artist, album: album)
        view.addSubview(activityIndicator)
    }
    
    
    func requestInfo(artist: String, album: String) {
        isLoading = true
        activityIndicator.startAnimating()
        AlbumInfoAPI().requestInfo(artist: artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                                   album: album.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            (response, error) in
            self.isLoading = false
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response {
                DispatchQueue.main.async {
                    self.listenersAmount.text = "Listeners: " + response.album.listeners
                    self.playcount.text = "Playcount: " + response.album.playcount
                    self.infoText.text = response.album.wiki.summary
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
            }
        }
    }
}
    
