//
//  AddViewController.swift
//  Secret Contacts
//
//  Created by Benjamin Inemugha on 16/06/2020.
//  Copyright © 2020 Techelopers. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class AddViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item : Entity? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item == nil{
            self.navigationItem.title = "Add New Contact"
        }
        else{
            self.navigationItem.title = item?.contactname
            nameField.text = item?.contactname
            numberField.text = item?.contactnumber
            //self.navigationItem.title = item?.contactnumber
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: Any) {
        if item == nil{
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
            let item = Entity(entity: entityDescription!, insertInto: pc)
            item.contactname = nameField.text
            item.contactnumber = numberField.text
            
        }else{
            item?.contactname = nameField.text
            item?.contactnumber = numberField.text
        }
        
        do{
            try pc.save()
        }
        catch{
            print(error)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func messageButton(_ sender: Any) {
        if MFMessageComposeViewController.canSendText(){
            let messageSheet = MFMessageComposeViewController()
            
            messageSheet.recipients = ["\(numberField.text!)"]
            messageSheet.body = " "
            messageSheet.messageComposeDelegate = self
            self.present(messageSheet, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warning", message: "Your device can't send message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
     
    
    @IBAction func callButton(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "tel://\(numberField.text!)")! as URL, options: [:], completionHandler: nil)
        
    }
}
