//
//  AnimalsInteractor.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

import Foundation
import Combine

protocol AnimalsUseCase {
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalModel], Error>
  func getFavourites() -> AnyPublisher<[AnimalModel], Error>
  func searchPhotos(animalsModel: [AnimalModel], query: String, favouritesAnimals: [AnimalModel]) -> AnyPublisher<[AnimalModel], Error>
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error>
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error>
}

class AnimalsInteractor: AnimalsUseCase {
  let repository: TheAnimalRepositoryProtocol
  
  required init(repository: TheAnimalRepositoryProtocol) {
    self.repository = repository
  }
  
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalModel], Error> {
    return repository.getAnimals(name)
  }
  
  func getFavourites() -> AnyPublisher<[AnimalModel], Error> {
    return repository.getFavourites()
  }
  
  func searchPhotos(animalsModel: [AnimalModel], query: String, favouritesAnimals: [AnimalModel]) -> AnyPublisher<[AnimalModel], Error> {
    return repository.searchPhotos(
      animalsModel: animalsModel,
      query: query,
      favouritesAnimals: favouritesAnimals
    )
  }
  
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error> {
    return repository.createFavourite(
      animalModel: animalModel,
      urlPhoto: urlPhoto,
      typeAnimal: typeAnimal
    )
  }
  
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error> {
    return repository.deleteFavourite(urlPhoto: urlPhoto)
  }
}
