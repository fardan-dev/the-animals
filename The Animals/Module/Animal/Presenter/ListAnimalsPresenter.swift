//
//  ListAnimalsPresenter.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//
import SwiftUI

struct AnimalItem: Identifiable {
  let id: UUID = UUID()
  let name: String
  let iconName: String
}

class ListAnimalsPresenter: ObservableObject {
  private var router = AnimalRouter()
  
  @Published var animals: [AnimalItem] = []
  
  func getAnimals() {
    animals = [
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
  
  func linkBuilder<Content: View>(for animal: String, @ViewBuilder content: () -> Content) -> some View {
    NavigationLink(destination: router.makeListSpecificAnimalsView(name: animal)) { content() }
  }
}
