//
//  AnimalModel.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//
import Foundation

struct AnimalModel: Equatable, Identifiable {
  let id: UUID = UUID()
  let name: String?
  var photos: [PhotoModel] = []
  let slogan: String?
  let locations: String?
  let isFavourite: Bool?
}

struct PhotoModel: Equatable, Identifiable {
  var id: UUID = UUID()
  var urlString: String
  var isFavourite: Bool = false
}
