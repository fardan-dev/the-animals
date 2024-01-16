//
//  LocaleDataSource.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//
import CoreData
import Combine

protocol LocaleDataSourceProtocol {
  func getFavourites() -> AnyPublisher<[AnimalEntity], Error>
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalEntity], Error>
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error>
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource {
  static let sharedInstance = LocaleDataSource()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TheAnimals")
    
    container.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("Unresolved error \(error!)")
      }
    }
    
    container.viewContext.automaticallyMergesChangesFromParent = false
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.shouldDeleteInaccessibleFaults = true
    container.viewContext.undoManager = nil
    
    return container
  }()
  
  private func newTaskContext() -> NSManagedObjectContext {
    let taskContext = persistentContainer.newBackgroundContext()
    taskContext.undoManager = nil
    
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return taskContext
  }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
  func getFavourites() -> AnyPublisher<[AnimalEntity], Error> {
    Future<[AnimalEntity], Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        do {
          let results = try taskContext.fetch(fetchRequest)
          var animalsEntity = [AnimalEntity]()
          for result in results {
            let animalEntity = AnimalEntity(
              name: result.value(forKey: "name") as? String,
              urlPhoto: result.value(forKey: "url_photo") as? String,
              slogan: result.value(forKey: "slogan") as? String,
              locations: result.value(forKey: "locations") as? String,
              typeAnimal: result.value(forKey: "type_animal") as? String,
              isFavourite: true
            )
            
            animalsEntity.append(animalEntity)
          }
          
          completion(.success(animalsEntity))
        } catch {
          completion(.failure(DatabaseError.invalidInstance))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func getFavourites(_ filter: String) -> AnyPublisher<[AnimalEntity], Error> {
    Future<[AnimalEntity], Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        fetchRequest.predicate = NSPredicate(format: "type_animal == %@", filter)
        
        do {
          let results = try taskContext.fetch(fetchRequest)
          var animalsEntity = [AnimalEntity]()
          for result in results {
            let animalEntity = AnimalEntity(
              name: result.value(forKey: "name") as? String,
              urlPhoto: result.value(forKey: "url_photo") as? String,
              slogan: result.value(forKey: "slogan") as? String,
              locations: result.value(forKey: "locations") as? String,
              typeAnimal: result.value(forKey: "type_animal") as? String,
              isFavourite: true
            )
            
            animalsEntity.append(animalEntity)
          }
          
          completion(.success(animalsEntity))
        } catch {
          completion(.failure(DatabaseError.invalidInstance))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func createFavourite(animalModel: AnimalModel, urlPhoto: String, typeAnimal: String) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.performAndWait {
        if let entity = NSEntityDescription.entity(forEntityName: "Animal", in: taskContext) {
          let animal = NSManagedObject(entity: entity, insertInto: taskContext)
          animal.setValue(animalModel.name, forKey: "name")
          animal.setValue(animalModel.slogan, forKey: "slogan")
          animal.setValue(animalModel.locations, forKey: "locations")
          animal.setValue(urlPhoto, forKey: "url_photo")
          animal.setValue(typeAnimal, forKey: "type_animal")
          animal.setValue(true, forKey: "is_favourite")
          
          do {
            try taskContext.save()
            completion(.success(true))
          } catch {
            completion(.failure(DatabaseError.requestFailed))
          }
        } else {
          completion(.failure(DatabaseError.invalidInstance))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func deleteFavourite(urlPhoto: String) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Animal")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "url_photo == %@", urlPhoto)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
          if batchDeleteResult.result != nil {
            completion(.success(true))
          } else {
            completion(.failure(DatabaseError.requestFailed))
          }
        } else {
          completion(.failure(DatabaseError.requestFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
}
