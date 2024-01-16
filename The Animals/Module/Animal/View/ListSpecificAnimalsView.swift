//
//  ListSpecificAnimalsView.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

import SwiftUI
import CachedAsyncImage

struct ListSpecificAnimalsView: View {
  @ObservedObject var presenter: ListSpecificAnimalsPresenter
  
  init(presenter: ListSpecificAnimalsPresenter) {
    self.presenter = presenter
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    UINavigationBar.appearance().tintColor = .white
  }
  
  var body: some View {
    ZStack {
      ScrollView {
        LazyVStack(spacing: 16) {
          ForEach(presenter.animals, id: \.id) { animal in
            ListAnimalRow(animalModel: animal, favouritePhoto: { urlPhoto, isFavourite in
              if isFavourite {
                presenter.deleteFavourite(urlPhoto: urlPhoto)
              } else {
                presenter.createFavourite(animalModel: animal, urlPhoto: urlPhoto)
              }
            })
              .onAppear {
                presenter.searchPhotos(query: animal.name ?? "")
              }
          }
        }
        .padding(.horizontal, 16)
      }
      .overlay {
        if presenter.isLoading {
          ProgressView()
        }
      }
    }
    .onAppear {
      presenter.getAnimals()
    }
    .navigationTitle(presenter.titlePage)
    .navigationBarTitleDisplayMode(.large)
    .alert(presenter.alertMessage, isPresented: $presenter.showingAlert) {
      Button("OK", role: .cancel) { }
    }
  }
}

struct ListAnimalRow: View {
  var animalModel: AnimalModel
  @State var currentIndex: Int = 0
  var favouritePhoto: (String, Bool) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if !animalModel.photos.isEmpty {
        SnapCarousel(spacing: 0, trailingSpace: 0, index: $currentIndex, items: animalModel.photos) { item in
          GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
              CachedAsyncImage(url: URL.init(string: item.urlString)) { image in
                image
                  .resizable()
              } placeholder: {
                Image("placeholder-potrait")
                  .resizable()
              }
              
              Button {
                favouritePhoto(item.urlString, item.isFavourite)
              } label: {
                Image(systemName: "heart.fill")
                  .foregroundColor(item.isFavourite ? .red:.white)
                  .frame(width: 32, height: 32)
              }
              .padding(.top, 8)
              .padding(.trailing, 8)
              .frame(width: 32, height: 32)

            }
          }
        }
        .aspectRatio(10/12, contentMode: .fit)
      } else {
        ZStack(alignment: .bottom) {
          Image("placeholder-potrait")
            .resizable()
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(10/12, contentMode: .fit)
      }
      
      HStack(spacing: 10) {
        Spacer()
        ForEach(animalModel.photos.indices, id: \.self) { index in
          ZStack {
            if currentIndex == index {
              Circle()
                .fill(Color.white)
                .frame(width: 5, height: 5)
            } else {
              Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 5, height: 5)
            }
          }
        }
        Spacer()
      }
      .padding(.vertical, 4)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(animalModel.name ?? "")
          .fontWeight(.semibold)
          .font(Font.headline)
        
        Text(animalModel.slogan ?? "")
          .fontWeight(.regular)
          .font(Font.headline)
        
        HStack(spacing: 4) {
          Image(systemName: "location.fill")
            .resizable()
            .frame(width: 12, height: 12)
          
          Text(animalModel.locations ?? "")
            .font(Font.body)
        }
      }
      .padding(16)
    }
    .frame(maxWidth: .infinity)
    .cornerRadius(12)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke()
        .foregroundColor(.white)
    }
  }
}

struct ListSpecificAnimalsView_Previews: PreviewProvider {
  static var previews: some View {
    ListAnimalRow(animalModel: AnimalModel(name: "Gajah", slogan: "Gajah ini mati kyanya", locations: "Jakarta, Indonesia", isFavourite: true), favouritePhoto: {_, _ in})
  }
}
