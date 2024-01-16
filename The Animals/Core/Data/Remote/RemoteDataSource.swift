//
//  RemoteDataSource.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//

import Alamofire
import Foundation
import Combine

struct Headers {
  enum BaseURL {
    case ninjas, pexels
  }
  
  static func getHeaders(_ baseUrl: BaseURL) -> HTTPHeaders {
    var headers = [HTTPHeader]()
    
    switch baseUrl {
    case .ninjas: headers.append(HTTPHeader(name: "X-Api-Key", value: getAPIKey("api-key-ninjas")))
    case .pexels: headers.append(HTTPHeader(name: "Authorization", value: getAPIKey("api-key-pexels")))
    }
    
    return HTTPHeaders(headers)
  }
  
  private static func getAPIKey(_ key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Constant", ofType: "plist")  else {
      fatalError("Couldn't find file 'Constant.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let url = plist?.object(forKey: key) as? String else {
      fatalError("Couldn't find key 'API-Key' in 'Constant.plist'.")
    }
    
    return url
  }
}

protocol RemoteDataSourceProtocol {
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalResponse], Error>
  func searchPhotos(_ key: String) -> AnyPublisher<[PhotoResponse], Error>
}

final class RemoteDataSource {
  static let sharedInstance = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalResponse], Error> {
    Future<[AnimalResponse], Error> { completion in
      AF
        .request(Endpoints.Gets.animals.url,
                 parameters: ["name": name],
                 encoding: URLEncoding.queryString,
                 headers: Headers.getHeaders(.ninjas))
        .validate()
        .responseDecodable(of: [AnimalResponse].self) { response in
          switch response.result {
          case .success(let animals):
            completion(.success(animals))
          case .failure:
            completion(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }
  
  func searchPhotos(_ query: String) -> AnyPublisher<[PhotoResponse], Error> {
    Future<[PhotoResponse], Error> { completion in
      AF
        .request(Endpoints.Gets.searchPhotos.url,
                 parameters: ["query": query,
                              "per_page": "10"],
                 encoding: URLEncoding.queryString,
                 headers: Headers.getHeaders(.pexels))
        .validate()
        .responseDecodable(of: PhotosResponse.self) { response in
          switch response.result {
          case .success(let photosResponse):
            completion(.success(photosResponse.photos))
          case .failure:
            completion(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }
}
