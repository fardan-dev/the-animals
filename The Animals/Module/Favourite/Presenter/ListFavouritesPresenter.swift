//
//  ListFavouritePresenter.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 15/01/24.
//

import Combine
import SwiftUI

class ListFavouritesPresenter: ObservableObject {
  private var cancellables: Set<AnyCancellable> = []
  private var favouritesUseCase: FavouritesUseCase
  private var isSearchPhotos: Bool = false
  
  @Published var animals: [AnimalModel] = []
  
  init(favouritesUseCase: FavouritesUseCase) {
    self.favouritesUseCase = favouritesUseCase
  }
}

extension ListFavouritesPresenter {
  func getFavourites() {
    favouritesUseCase.getFavourites()
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(_):
          break
        }
      } receiveValue: { animals in
        self.animals = animals
      }.store(in: &cancellables)
  }
  
  func getFavourites(_ filter: String) {
    favouritesUseCase.getFavourites(filter)
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(_):
          break
        }
      } receiveValue: { animals in
        self.animals = animals
      }.store(in: &cancellables)
  }
  
  func deleteFavourite(urlPhoto: String) {
    favouritesUseCase.deleteFavourite(urlPhoto: urlPhoto)
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(_):
          break
        }
      } receiveValue: { isSuccessRemove in
        if isSuccessRemove {
          self.getFavourites()
        }
      }.store(in: &cancellables)
  }
  
  func getAnimals() -> [AnimalItem] {
    [
      AnimalItem(name: "Elephant", iconName: "elephant-ic"),
      AnimalItem(name: "Lion", iconName: "lion-ic"),
      AnimalItem(name: "Fox", iconName: "fox-ic"),
      AnimalItem(name: "Dog", iconName: "dog-ic"),
      AnimalItem(name: "Shark", iconName: "shark-ic"),
      AnimalItem(name: "Turtle", iconName: "turtle-ic"),
      AnimalItem(name: "Whale", iconName: "whale-ic"),
      AnimalItem(name: "Penguin", iconName: "penguin-ic")
    ]
  }
}
