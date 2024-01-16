//
//  Injection.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//
import Foundation

final class Injection: NSObject {
  private func provideRepository() -> TheAnimalRepositoryProtocol {
    let remote = RemoteDataSource.sharedInstance
    let locale = LocaleDataSource.sharedInstance
    
    return TheAnimalRepository.sharedInstance(remote, locale)
  }
  
  func provideListSpecificAnimals() -> AnimalsUseCase {
    let repository = provideRepository()
    return AnimalsInteractor(repository: repository)
  }
  
  func provideListFavourites() -> FavouritesUseCase {
    let repository = provideRepository()
    return FavouritesInteractor(repository: repository)
  }
}
