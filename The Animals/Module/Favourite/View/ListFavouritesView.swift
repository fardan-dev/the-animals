//
//  ListFavouritesView.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 15/01/24.
//

import SwiftUI

struct ListFavouritesView: View {
  @ObservedObject var presenter: ListFavouritesPresenter
  
  @State var showFilter: Bool = false
  
  init(presenter: ListFavouritesPresenter) {
    self.presenter = presenter
  }
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(presenter.animals, id: \.id) { animal in
          ListAnimalRow(animalModel: animal) { urlString, _ in
            self.presenter.deleteFavourite(urlPhoto: urlString)
          }
        }
      }
      .padding(.horizontal, 16)
    }
    .onAppear {
      presenter.getFavourites()
    }
    .navigationTitle("Favourites")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem {
        Button {
          showFilter = true
        } label: {
          Image(systemName: "line.3.horizontal.decrease.circle.fill")
        }
      }
    }
    .sheet(isPresented: $showFilter) {
      ScrollView {
        VStack(spacing: 16) {
          HStack {
            Text("Filter by animal")
              .font(Font.headline)
            
            Spacer()
          }
          .padding(.bottom, 16)
          
          ForEach(presenter.getAnimals(), id: \.id) { animal in
            HStack {
              Button {
                presenter.getFavourites(animal.name)
                showFilter = false
              } label: {
                HStack(spacing: 4) {
                  Image(animal.iconName)
                    .renderingMode(.template)
                    .foregroundColor(.white)
                  
                  Text(animal.name)
                    .font(Font.body)
                    .foregroundColor(.white)
                }
              }
              
              Spacer()
            }
          }
          
          HStack {
            Button {
              presenter.getFavourites()
              showFilter = false
            } label: {
              Text("Clear filter")
                .font(Font.body)
            }
            
            Spacer()
          }
        }
        .padding(16)
        .presentationDetents([.height(400)])
      }
    }
  }
}
