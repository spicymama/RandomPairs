//
//  PersonController.swift
//  RandomPairs_3
//
//  Created by Gavin Woffinden on 7/28/21.
//

import Foundation
import CoreData

class PersonController {
    
    static let shared = PersonController()
    
    var people: [Person] = []
    
    private lazy var fetchRequest: NSFetchRequest<Person> = {
        let request = NSFetchRequest<Person>(entityName: "Person")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    func createPerson(name: String) {
        let newPerson = Person(name: name)
        people.append(newPerson)
        CoreDataStack.saveContext()
    }
    
    func deletePerson(person: Person) {
        if let index = people.firstIndex(of: person) {
            people.remove(at: index)}
        CoreDataStack.context.delete(person)
        CoreDataStack.saveContext()
    }
    
    func fetchPerson() {
        let person = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        people = person
    }
}
