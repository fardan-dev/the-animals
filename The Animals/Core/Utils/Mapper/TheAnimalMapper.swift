//
//  TheAnimalMapper.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 12/01/24.
//

final class TheAnimalMapper {
  static func mapAnimalsResponseToDomains(input animalsResponse: [AnimalResponse]) -> [AnimalModel] {
    return animalsResponse.map { result in
      return AnimalModel(
        name: result.name ?? "",
        slogan: result.characteristics?.slogan ?? "",
        locations: result.locations?.joined(separator: ", ") ?? "",
        isFavourite: true)
    }
  }
  
  static func mapPhotosResponseToAnimalsDomain(name: String, animalsModel: [AnimalModel], photosResponse: [PhotoResponse], favouritesAnimals: [AnimalModel]) -> [AnimalModel] {
    let photosModel: [PhotoModel] = photosResponse.map { result in
      var isFavourite: Bool = false
      
      if favouritesAnimals.count > 0 {
        isFavourite = favouritesAnimals.filter { ($0.photos.first?.urlString ?? "").contains(result.src?.portrait ?? "") }.count > 0
      }
      
      return PhotoModel(
        urlString: result.src?.portrait ?? "",
        isFavourite: isFavourite
      )
    }
    
    return animalsModel.map { result in
      var animalModel = result
      if animalModel.name == name {
        animalModel.photos = photosModel
      }
      return animalModel
    }
  }
  
  static func mapAnimalsEntityToDomain(input animalsEntity: [AnimalEntity]) -> [AnimalModel] {
    return animalsEntity.map { result in
      return AnimalModel(
        name: result.name,
        photos: [PhotoModel(urlString: result.urlPhoto ?? "", isFavourite: true)],
        slogan: result.slogan,
        locations: result.locations,
        isFavourite: result.isFavourite
      )
    }
  }
}
