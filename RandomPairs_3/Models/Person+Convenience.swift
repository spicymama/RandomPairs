//
//  Person+Convenience.swift
//  RandomPairs_3
//
//  Created by Gavin Woffinden on 7/28/21.
//

import Foundation
import CoreData


extension Person {
    
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
    }
}
