//
//  APICall.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//

import Foundation

struct APICall {
  enum Host: String {
    case ninjas
    case pexels
    
    public var baseUrl: String {
      switch self {
      case .ninjas: return getBaseURL("base-url-ninjas")
      case .pexels: return getBaseURL("base-url-pexels")
      }
    }
  }
  
  private static func getBaseURL(_ key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Constant", ofType: "plist")  else {
      fatalError("Couldn't find file 'Constant.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let url = plist?.object(forKey: key) as? String else {
      fatalError("Couldn't find key 'base-url' in 'Constant.plist'.")
    }
    
    return url
  }
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
  enum Gets: Endpoint {
    case animals
    case searchPhotos
    
    public var url: String {
      switch self {
      case .animals: return "\(APICall.Host.ninjas.baseUrl)v1/animals"
      case .searchPhotos: return "\(APICall.Host.pexels.baseUrl)v1/search"
      }
    }
  }
}
