//
//  FavouritesInteractor.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 15/01/24.
//

import Foundation
import Combine

protocol FavouritesUseCase {
  func getFavourites() -> AnyPublisher<[AnimalModel], Error>
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalModel], Error>
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error>
}

class FavouritesInteractor: FavouritesUseCase {
  let repository: TheAnimalRepositoryProtocol
  
  required init(repository: TheAnimalRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavourites() -> AnyPublisher<[AnimalModel], Error> {
    return repository.getFavourites()
  }
  
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalModel], Error> {
    return repository.getFavourites(filter)
  }
  
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error> {
    return repository.deleteFavourite(urlPhoto: urlPhoto)
  }
}
