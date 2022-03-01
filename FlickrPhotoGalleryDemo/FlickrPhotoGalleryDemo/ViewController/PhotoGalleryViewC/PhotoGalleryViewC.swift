//
//  PhotoGalleryViewC.swift
//  FlickrPhotoGalleryDemo
//
//  Created by Ezeugo Chukwunyere on 2/28/22.
//

import UIKit
import SVPullToRefresh

class PhotoGalleryViewC: UIViewController {
    private let photoGalleryViewModel = PhotoGalleryViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewPhotoGallery: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        refreshViewData()
        
        tblViewPhotoGallery.addInfiniteScrolling {
            self.photoGalleryViewModel.currentPage += 1
            
            if self.photoGalleryViewModel.currentPage != self.photoGalleryViewModel.photoGallery.photos.pages {
                self.refreshViewData()
            } else {
                self.tblViewPhotoGallery.infiniteScrollingView.stopAnimating()
            }
        }
    }
    
    private func refreshViewData() {
        photoGalleryViewModel.callGetPhotoLibrary {
            if self.tblViewPhotoGallery.showsInfiniteScrolling {
                self.tblViewPhotoGallery.infiniteScrollingView.stopAnimating()
            }
            self.tblViewPhotoGallery.reloadData()
        }
    }
}

extension PhotoGalleryViewC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photoGalleryViewModel.photoGallery == nil { return 0 }
        return photoGalleryViewModel.photoGallery.photos.photo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        getPhotoGalleryTableViewCell(forIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardConstants.kMain, bundle: nil)
        let photoPreviewViewC = storyboard.instantiateViewController(withIdentifier: PhotoPreviewViewC.identifier()) as! PhotoPreviewViewC
        photoPreviewViewC.photoPreviewViewModel.photoGalleryItem = photoGalleryViewModel.photoGallery.photos.photo[indexPath.row]
        navigationController?.present(photoPreviewViewC, animated: true, completion: nil)
    }
    
    private func getPhotoGalleryTableViewCell(forIndexPath indexPath: IndexPath) -> PhotoGalleryTableViewCell {
        let photoGalleryTableViewCell = tblViewPhotoGallery.dequeueReusableCell(withIdentifier: PhotoGalleryTableViewCell
                                                                                    .identifier(), for: indexPath) as! PhotoGalleryTableViewCell
        photoGalleryTableViewCell.configureCell(withPhotoGalleryItem: photoGalleryViewModel.photoGallery.photos.photo[indexPath.row], forIndexPath: indexPath)
        return photoGalleryTableViewCell
    }
}

extension PhotoGalleryViewC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let searchBarText = searchBar.text, let textRange = Range(range, in: searchBarText) {
            
            let updatedText = searchBarText.replacingCharacters(in: textRange, with: text).lowercased()
            if updatedText.isEmpty {
                photoGalleryViewModel.photoGallery = nil
                tblViewPhotoGallery.reloadData()
            } else {
                photoGalleryViewModel.strSearchedText = updatedText
                photoGalleryViewModel.currentPage = 1
                refreshViewData()
            }
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            photoGalleryViewModel.photoGallery = nil
            tblViewPhotoGallery.reloadData()
        }
    }
}
