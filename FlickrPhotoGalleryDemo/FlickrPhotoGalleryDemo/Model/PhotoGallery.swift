//
//  PhotoGallery.swift
//  FlickrPhotoGalleryDemo
//
//  Created by Ezeugo Chukwunyere on 2/28/22.
//

import Foundation

struct PhotoGallery: Decodable {
  var photos: PhotoGalleryData
  let stat: String
  
  enum CodingKeys: String, CodingKey {
    case photos
    case stat
  }
}

struct PhotoGalleryData: Decodable {
  var page: Int
  var pages: Int
  let perpage: Int
  var total: Int
  var photo: [PhotoGalleryItem]
  
  enum CodingKeys: String, CodingKey {
    case page
    case pages
    case perpage
    case total
    case photo
  }
}

struct PhotoGalleryItem: Decodable {
  let id: String
  let owner: String
  let secret: String
  let server: String
  let farm: Int
  let title: String
  let ispublic: Int
  let isfriend: Int
  let isfamily: Int
  
  enum CodingKeys: String, CodingKey {
    case id
    case owner
    case secret
    case server
    case farm
    case title
    case ispublic
    case isfriend
    case isfamily
  }
}
