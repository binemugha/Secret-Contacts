//
//  AddViewController.swift
//  Secret Contacts
//
//  Created by Benjamin Inemugha on 16/06/2020.
//  Copyright © 2020 Techelopers. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: Any) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
        let item = Entity(entity: entityDescription!, insertInto: pc)
        item.contactname = nameField.text
        item.contactnumber = numberField.text
     
        do{
            try pc.save()
        }
        catch{
            print(error)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
}
