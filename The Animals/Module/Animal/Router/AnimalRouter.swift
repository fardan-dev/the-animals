//
//  AnimalRouter.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

import SwiftUI

class AnimalRouter {
  func makeListSpecificAnimalsView(name: String) -> some View {
    let specificAnimalPresenter = ListSpecificAnimalsPresenter(
      animalName: name,
      animalsUseCase: Injection().provideListSpecificAnimals()
    )
    
    return ListSpecificAnimalsView(presenter: specificAnimalPresenter)
  }
  
  func makeListFavouritesView() -> some View {
    let favouritesPresenter = ListFavouritesPresenter(
      favouritesUseCase: Injection().provideListFavourites()
    )
    
    return ListFavouritesView(presenter: favouritesPresenter)
  }
}
