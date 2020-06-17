//
//  ContactTableViewController.swift
//  Secret Contacts
//
//  Created by Benjamin Inemugha on 16/06/2020.
//  Copyright © 2020 Techelopers. All rights reserved.
//

import UIKit
import CoreData

class ContactTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let sorter = NSSortDescriptor(key: "contactname", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        return fetchRequest
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }
        catch{
            print(error)
            return
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCells = frc.sections?[section].numberOfObjects
        return numberOfCells!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell

        // Configure the cell...
        let item = frc.object(at: indexPath) as! Entity
        cell.cellLabel.text = item.contactname

        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject : NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        pc.delete(managedObject)
        
        do{
            try pc.save()
        }
        
        catch{
            print(error)
            return
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let itemController : AddViewController = segue.destination as! AddViewController
            let item : Entity = frc.object(at: indexPath!) as! Entity
            
            itemController.item = item
        
            
        }
    }
    

}
