//
//  CoreCharacterService.swift
//  Ricked
//
//  Created by Антон Нехаев on 07.07.2023.
//

import Foundation
import CoreData


class CoreCharacterService {
    
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    init(delegate: NSFetchedResultsControllerDelegate? = nil) {
        self.delegate = delegate
    }
    
    lazy var frc: NSFetchedResultsController<CoreCharacter> = {
        let request = CoreCharacter.fetchRequest()
        request.sortDescriptors = [
            .init(key: "givenId", ascending: true),
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = delegate
        
        return frc
    }()
    
    func countInSection(at section: Int) -> Int {
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func fetchCharacter(at indexPath: IndexPath) -> CoreCharacter {
        frc.object(at: indexPath)
    }
    
    func fetchChracter(id: Int64) -> CoreCharacter? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreCharacter")
            fetchRequest.predicate = NSPredicate(format: "givenId == %lld", id)
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest) as? [CoreCharacter]
            return results?.first
        } catch {
            // handle error
            return nil
        }
    }
    
    func cacheUICharacters(_ characters: [Character]) {
        for character in characters {
            PersistentContainer.shared.performBackgroundTask { [character, weak self] backgroundContext in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreCharacter")
                fetchRequest.predicate = NSPredicate(format: "givenId == %lld", Int64(character.id))
                let results = try? backgroundContext.fetch(fetchRequest) as? [CoreCharacter]
                if (results?.first) != nil {
                    return
                } else {
                    let newEntry = CoreCharacter(context: backgroundContext)
                    newEntry.gender = character.getGenderString()
                    newEntry.status = character.getStatusString()
                    newEntry.name = character.name
                    newEntry.image = character.image
                    newEntry.species = character.species
                    newEntry.givenId = Int64(character.id)
                    newEntry.location = character.location
                    PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
                }
            }
        }
    }
    
    func translateToUIModel(coreCharacter: CoreCharacter) -> Character {
        Character(id: Int(coreCharacter.givenId), name: coreCharacter.name ?? "",
                                 status: Character.Status(rawValue: coreCharacter.status ?? "") ?? .alive,
                                 species: coreCharacter.species ?? "",
                                 gender: Character.Gender(rawValue: coreCharacter.gender ?? "") ?? .unknown,
                                 location: coreCharacter.location ?? "",
                                 image: coreCharacter.image ?? "")
    }
    
    func retrieveCharacters() -> [Character] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreCharacter")
        fetchRequest.sortDescriptors = [
            .init(key: "givenId", ascending: true),
        ]
        var results: [Character] = .init()
        
        do {
            var res = (try? PersistentContainer.shared.viewContext.fetch(fetchRequest) as? [CoreCharacter]) ?? []
            res.forEach { coreCharacter in
                results.append(translateToUIModel(coreCharacter: coreCharacter)
                )
            }
            
            return results
        }
    }
    
    func clear() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreCharacter")
        PersistentContainer.shared.performBackgroundTask { backgroundContext in
            try? backgroundContext.fetch(fetchRequest).forEach { element in
                if let element = element as? CoreCharacter {
                    backgroundContext.delete(element)
                }
            }
            PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
        }
    }
}
