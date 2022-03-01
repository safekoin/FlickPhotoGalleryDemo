//
//  PhotoGalleryViewModel.swift
//  FlickrPhotoGalleryDemo
//
//  Created by Ezeugo Chukwunyere on 2/28/22.
//

import Foundation

let PER_PAGE_ITEM_COUNT = 25

class PhotoGalleryViewModel {
  
  //MARK: - ----------Public Variables---------- -
  var photoGallery: PhotoGallery!
  var currentPage = 1
  var strSearchedText = ""
  
  //MARK: - ----------WebService Methods---------- -
  func callGetPhotoLibrary(_ completionClosure: @escaping () -> ()) {
    
    let dictParams: Dictionary<String, Any> = [KeyConstants.kAPIKey: FLICKR_API_KEY,
                                               KeyConstants.kMethod: WebServiceName.kPhotoSearch,
                                               KeyConstants.kPage: currentPage,
                                               KeyConstants.kPerPage: PER_PAGE_ITEM_COUNT,
                                               KeyConstants.kFormat: "json",
                                               KeyConstants.kText: strSearchedText,
                                               KeyConstants.kNoJSONCallBack: 1]
    
    NetworkManager.shared.requestAPI(withName: "", requestMethod: .get, requestParameters: dictParams, withDecodable: PhotoGallery.self) { result, error, statusCode in
      if self.currentPage == 1 {
        self.photoGallery = result
      } else {
        guard let photoGalleryData = result else { return }
        self.photoGallery.photos.page = photoGalleryData.photos.page
        self.photoGallery.photos.pages = photoGalleryData.photos.pages
        self.photoGallery.photos.total = photoGalleryData.photos.total
        self.photoGallery.photos.photo.append(contentsOf: photoGalleryData.photos.photo)
      }
      completionClosure()
    }
  }
}
