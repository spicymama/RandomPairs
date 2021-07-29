//
//  PersonListTableViewController.swift
//  RandomPairs_3
//
//  Created by Gavin Woffinden on 7/28/21.
//

import UIKit
import CoreData

class PersonListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.fetchPerson()
        let people = PersonController.shared.people
        PersonController.shared.people = []
        reorderSections(allPeople: people)
        tableView.reloadData()
    
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        sections = []
        let people = PersonController.shared.people
        PersonController.shared.people = []
        shuffleSections(allPeople: people)
        tableView.reloadData()
        CoreDataStack.saveContext()
    }
    
    var sections: [[Person]] = []
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add a Name", message: "Example: Bob", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name Here..."
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { (_) in
            let newPerson = Person(name: (alertController.textFields?.first?.text)!)
            PersonController.shared.people.append(newPerson)
            CoreDataStack.saveContext()
            if self.sections.last?.count == 1 {
                self.sections[self.sections.count-1].append(newPerson)
            } else {
            self.sections.append([newPerson])
                }
            alertController.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func shuffleSections(allPeople: [Person]) {
        guard allPeople.count != 0 else {return}
        if allPeople.count == 1 {
            let person = allPeople.first!
            sections.append([person])
            PersonController.shared.people.append(person)
            return
        }
        var people = allPeople
        let randomPerson1 = Int(arc4random_uniform(UInt32(people.count)))
        let person1 = people.remove(at: randomPerson1)
        let randomPerson2 = Int(arc4random_uniform(UInt32(people.count)))
        let person2 = people.remove(at: randomPerson2)
        PersonController.shared.people.append(contentsOf: [person1, person2])
        sections.append([person1, person2])
        shuffleSections(allPeople: people)
        
    }
    
    func reorderSections(allPeople: [Person]) {
        guard allPeople.count != 0 else {return}
        if allPeople.count == 1 {
            let person = allPeople.first!
            sections.append([person])
            PersonController.shared.people.append(person)
            return
        }
        
        var people = allPeople
        let person1 = people.removeFirst()
        let person2 = people.removeFirst()
        PersonController.shared.people.append(contentsOf: [person1, person2])
        sections.append([person1, person2])
        reorderSections(allPeople: people)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section+1)"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let section = sections[indexPath.section]
        let person = section[indexPath.row]

        cell.textLabel?.text = person.name
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexNumber = indexPath.section*2+indexPath.row
            sections = []
            var people = PersonController.shared.people
            
            if people.count % 2 != 0 {
                
                people.remove(at: indexNumber)
                PersonController.shared.people = []
                reorderSections(allPeople: people)
                tableView.deleteSections([tableView.numberOfSections-1], with: .fade)
            } else {
                let person = people.remove(at: indexNumber)
                PersonController.shared.deletePerson(person: person)
                PersonController.shared.people = []
                reorderSections(allPeople: people)
                tableView.deleteRows(at: [IndexPath(item: 1, section: tableView.numberOfSections-1)], with: .fade)
            }
        }
        CoreDataStack.saveContext()
        tableView.reloadData()
    }
}
