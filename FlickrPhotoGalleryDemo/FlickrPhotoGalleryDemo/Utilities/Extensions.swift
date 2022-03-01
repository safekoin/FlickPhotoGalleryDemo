//
//  Extensions.swift
//  FlickrPhotoGalleryDemo
//
//  Created by Ezeugo Chukwunyere on 2/28/22.
//

import Foundation
import UIKit

extension UITableViewCell {
  static func identifier() -> String {
    String(describing: self)
  }
}

extension UIViewController {
  static func identifier() -> String {
    String(describing: self)
  }
}

extension UIStoryboard {
  static func identifier() -> String {
    String(describing: self)
  }
}
