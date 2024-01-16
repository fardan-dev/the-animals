//
//  ListAnimalsView.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

import SwiftUI

struct ListAnimalsView: View {
  private var router = AnimalRouter()
  @ObservedObject var presenter = ListAnimalsPresenter()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(presenter.animals, id: \.id) { item in
          ZStack {
            NavigationLink {
              self.router.makeListSpecificAnimalsView(name: item.name)
            } label: {
              HStack(spacing: 8) {
                Image(item.iconName)
                  .renderingMode(.template)
                  .foregroundColor(.white)
                
                Text(item.name)
              }
            }
          }
        }
      }
      .navigationTitle("The Animals")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem {
          NavigationLink {
            self.router.makeListFavouritesView()
          } label: {
            Image(systemName: "heart.fill")
          }
        }
      }
    }
    .onAppear {
      presenter.getAnimals()
    }
    .accentColor(.white)
  }
}

struct ListAnimalsView_Previews: PreviewProvider {
  static var previews: some View {
    ListAnimalsView()
  }
}
