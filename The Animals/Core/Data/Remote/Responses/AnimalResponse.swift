//
//  AnimalResponse.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//
import Foundation

// MARK: - AnimalResponse
struct AnimalResponse: Codable {
  let name: String?
  let locations: [String]?
  let characteristics: Characteristics?
}

// MARK: - Characteristics
struct Characteristics: Codable {
  let slogan: String?
}
