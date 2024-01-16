//
//  PhotoResponse.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//
import Foundation

struct PhotosResponse: Codable {
  let photos: [PhotoResponse]
}

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
  let id: Int?
  let src: Src?
}

// MARK: - Src
struct Src: Codable {
  let portrait: String
}
