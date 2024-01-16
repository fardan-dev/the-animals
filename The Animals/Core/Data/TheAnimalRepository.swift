//
//  TheAnimalRepository.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

import Foundation
import Combine

protocol TheAnimalRepositoryProtocol {
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalModel], Error>
  func searchPhotos(animalsModel: [AnimalModel], query: String, favouritesAnimals: [AnimalModel]) -> AnyPublisher<[AnimalModel], Error>
  func getFavourites() -> AnyPublisher<[AnimalModel], Error>
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalModel], Error>
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error>
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error>
}

final class TheAnimalRepository {
  typealias TheAnimalInstance = (RemoteDataSource, LocaleDataSource) -> TheAnimalRepository
  fileprivate let remote: RemoteDataSource
  fileprivate let locale: LocaleDataSource
  
  static var sharedInstance: TheAnimalInstance = { remoteRepo, localeRepo in
    return TheAnimalRepository(remote: remoteRepo, locale: localeRepo)
  }
  
  private init(remote: RemoteDataSource, locale: LocaleDataSource) {
      self.remote = remote
      self.locale = locale
  }
}

extension TheAnimalRepository: TheAnimalRepositoryProtocol {
  func getAnimals(_ name: String) -> AnyPublisher<[AnimalModel], Error> {
    return remote.getAnimals(name)
      .map { TheAnimalMapper.mapAnimalsResponseToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func searchPhotos(animalsModel: [AnimalModel], query: String, favouritesAnimals: [AnimalModel]) -> AnyPublisher<[AnimalModel], Error> {
    return remote.searchPhotos(query)
      .map {
        TheAnimalMapper
          .mapPhotosResponseToAnimalsDomain(
            name: query,
            animalsModel: animalsModel,
            photosResponse: $0,
            favouritesAnimals: favouritesAnimals
          )
      }
      .eraseToAnyPublisher()
  }
  
  func getFavourites() -> AnyPublisher<[AnimalModel], Error> {
    return locale.getFavourites()
      .map { TheAnimalMapper.mapAnimalsEntityToDomain(input: $0)}
      .eraseToAnyPublisher()
  }
  
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalModel], Error> {
    return locale.getFavourites(filter)
      .map { TheAnimalMapper.mapAnimalsEntityToDomain(input: $0)}
      .eraseToAnyPublisher()
  }
  
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error> {
    return locale.createFavourite(animalModel: animalModel, urlPhoto: urlPhoto, typeAnimal: typeAnimal)
  }
  
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error> {
    return locale.deleteFavourite(urlPhoto: urlPhoto)
  }
}
