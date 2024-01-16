//
//  ListSpecificAnimalsPresenter.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//
import SwiftUI
import Combine

class ListSpecificAnimalsPresenter: ObservableObject {
  private var cancellables: Set<AnyCancellable> = []
  private var animalName: String
  private var animalsUseCase: AnimalsUseCase
  private var isSearchPhotos: Bool = false
  private var listQueuePhotos: [String] = []
  
  @Published var isLoading = false
  @Published var alertMessage = ""
  @Published var showingAlert = false
  @Published var titlePage: String = ""
  @Published var animals: [AnimalModel] = []
  
  init(animalName: String, animalsUseCase: AnimalsUseCase) {
    self.animalName = animalName
    self.animalsUseCase = animalsUseCase
    self.titlePage = animalName
  }
  
  private func readyToSearchPhotos(query: String) -> Bool {
    if animals.filter({ $0.name == query}).first?.photos.isEmpty == true, !isSearchPhotos {
      if !listQueuePhotos.contains(query) {
        listQueuePhotos.append(query)
      }
      
      return true
    } else if animals.filter({ $0.name == query}).first?.photos.isEmpty == true {
      if !listQueuePhotos.contains(query) {
        listQueuePhotos.append(query)
      }
      
      return false
    }
    
    return false
  }
  
  private func getFavouritesAnimals(completion: @escaping ([AnimalModel]) -> Void) {
    animalsUseCase.getFavourites()
      .receive(on: RunLoop.main)
      .sink { _ in } receiveValue: { animals in
        completion(animals)
      }.store(in: &cancellables)
  }
}

extension ListSpecificAnimalsPresenter {
  func getAnimals() {
    isLoading = true
    
    animalsUseCase.getAnimals(animalName)
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.alertMessage = error.localizedDescription
          self.showingAlert = true
        }
      } receiveValue: { animals in
        self.animals = animals
      }.store(in: &cancellables)
  }
  
  func searchPhotos(query: String) {
    guard readyToSearchPhotos(query: query) else { return }
    isSearchPhotos = true
    
    getFavouritesAnimals { favourites in
      self.animalsUseCase.searchPhotos(
        animalsModel: self.animals,
        query: self.listQueuePhotos.first ?? "",
        favouritesAnimals: favourites
      )
        .receive(on: RunLoop.main)
        .sink { completion in
          switch completion {
          case .finished:
            self.isSearchPhotos = false
            
            if self.listQueuePhotos.count > 0 {
              self.listQueuePhotos.remove(at: 0)
              self.searchPhotos(query: self.listQueuePhotos.first ?? "")
            }
          case .failure(_): return
          }
        } receiveValue: { animals in
          self.animals = animals
        }.store(in: &self.cancellables)
    }
  }
  
  func createFavourite(animalModel: AnimalModel, urlPhoto: String) {
    animalsUseCase.createFavourite(
      animalModel: animalModel,
      urlPhoto: urlPhoto,
      typeAnimal: animalName
    )
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished: return
        case .failure(let error):
          self.alertMessage = error.localizedDescription
          self.showingAlert = true
        }
      } receiveValue: { isSuccess in
        self.animals = self.animals.map { result in
          var animal = result
          for (index, photo) in result.photos.enumerated() {
            if photo.urlString == urlPhoto {
              animal.photos[index].isFavourite = true
            }
          }
          return animal
        }
      }.store(in: &cancellables)
  }
  
  func deleteFavourite(urlPhoto: String) {
    animalsUseCase.deleteFavourite(urlPhoto: urlPhoto)
      .receive(on: RunLoop.main)
      .sink { completion in
        switch completion {
        case .finished: return
        case .failure(let error):
          self.alertMessage = error.localizedDescription
          self.showingAlert = true
        }
      } receiveValue: { isSuccess in
        if isSuccess {
          self.animals = self.animals.map { result in
            var animal = result
            for (index, photo) in result.photos.enumerated() {
              if photo.urlString == urlPhoto {
                animal.photos[index].isFavourite = false
              }
            }
            return animal
          }
        }
      }.store(in: &cancellables)
  }
}
