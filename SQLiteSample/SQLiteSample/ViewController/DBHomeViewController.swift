//
//  DBHomeViewController.swift
//  SQLiteSample
//
//  Created by Vidya R on 11/12/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit
import FMDB
class DBHomeViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var addressText: UITextField!
    
    @IBOutlet weak var phnText: UITextField!
    var fileURL = NSURL()
    
    let databaseFileName = "jsonDatabase.sqlite"
    var pathToDatabase: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createDatabase()
    }

    func createDatabase()
    {
      
        let fileManager = FileManager.default
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        fileURL = documentsPath.appendingPathComponent("test2.db")! as NSURL
        print(fileURL)
        
        
        if !fileManager.fileExists(atPath: fileURL.path!) {
            
            let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                
                
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton)
    {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
        
        
        if contactDB.open() {

                    let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(nameText.text!)', '\(addressText.text!)', '\(phnText.text!)')"
                 
                    
                 
                   var result = Bool()
                    
                    do {
                        try contactDB.executeUpdate(insertSQL, values: nil)
                       
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
            
                
                contactDB.commit()
                contactDB.close()
           
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    @IBAction func findAction(_ sender: UIButton) {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
        if contactDB.open() {
            let nameValue = nameText.text!
           
            let query = "select phone,address from contacts where name =" + "'\(nameValue)'"
            
            do {
                print(contactDB)
                let results = try contactDB.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    print(results.string(forColumn: "phone")!)
                    addressText.text = results.string(forColumn: "address")!
                    phnText.text = results.string(forColumn: "phone")!
                    
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            contactDB.close()
        }
        
        

        
    }
  
    @IBAction func deleteAction(_ sender: UIButton) {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
        if contactDB.open() {
            let query = "delete from CONTACTS where name="+"'\(nameText.text!)'"
            
            do {
                try contactDB.executeUpdate(query, values: nil)
                
            }
            catch {
                print(error.localizedDescription)
            }
            
            contactDB.close()
        }
        
        
    }
    @IBAction func updateAction(_ sender: UIButton) {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
        if contactDB.open() {
            let query = "update contacts set address=" + "'\(addressText.text!)'" + "where name =" + "'\(nameText.text!)'"
            
            do {
                try contactDB.executeUpdate(query, values: nil)
            }
            catch {
                print(error.localizedDescription)
            }
            
            contactDB.close()
        }
    }
    

}
