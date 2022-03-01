//
//  NetworkManager.swift
//  FlickrPhotoGalleryDemo
//
//  Created by Ezeugo Chukwunyere on 2/28/22.
//

import Foundation
import Alamofire
import AlamofireImage

let BASE_URL = "https://www.flickr.com/services/rest/"
let IMAGE_BASE_URL = "https://live.staticflickr.com/"
let FLICKR_API_KEY = "1508443e49213ff84d566777dc211f2a"

class NetworkManager {
  static let shared: NetworkManager = {
    return NetworkManager()
  }()
  
  func requestAPI<T: Decodable>(withName apiName: String, requestMethod method: HTTPMethod, requestParameters params: Dictionary<String, Any>, withDecodable decodable: T.Type, completionClosure:@escaping (_ result: T?, _ error: Error?, _ statusCode: Int) -> ()) {
    
    if NetworkReachabilityManager()?.isReachable == true {
      
      let headers = getHeader()
      let serviceUrl = getServiceUrl(withAPIName: apiName)
      
      switch method {
      case .get:
        AF.request(serviceUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseDecodable(of: T.self) { dataResponse in
          switch dataResponse.result {
          case .success:
            let response = self.getResultFromResponse(dataResponse, withDecodable: decodable)
            completionClosure(response.responseData, dataResponse.error, dataResponse.response?.statusCode ?? 000)
          case .failure(let error):
            completionClosure(nil, error, dataResponse.response?.statusCode ?? 000)
          }
        }
      default:
        completionClosure(nil, nil, 500)
      }
    } else {
      completionClosure(nil, nil, 500)
    }
  }
  
  private func getHeader() -> HTTPHeaders {
    
    var headers: HTTPHeaders = []
    headers.add(HTTPHeader.init(name: "Content-Type", value: "application/json"))
    return headers
  }
  
  private func getServiceUrl(withAPIName apiName: String) -> String {
    return BASE_URL + apiName
  }
  
  private func getResultFromResponse<T: Decodable>(_ dataResponse: DataResponse<T, AFError>, withDecodable decodable: T.Type) -> (responseData: T?, error: Error?) {
    do {
      let responseData = try dataResponse.result.get()
      return (responseData, nil)
    }
    catch let error {
      return (nil, error)
    }
  }
  
  private func getResponseDataDictionaryFromData<T: Decodable>(data: Data, withDecodable decodable: T.Type) -> (responseData: T?, error: Error?) {
    do {
      guard let responseData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? T else {
        return (nil, nil)
      }
      return (responseData, nil)
    }
    catch let error {
      return (nil, error)
    }
  }
}
