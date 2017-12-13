//
//  JSONListViewController.swift
//  SQLiteSample
//
//  Created by Vidya R on 12/12/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit
import FMDB
class JSONListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listTableView: UITableView!
    
var fileURL = NSURL()
    var personInformation = NSArray()
    var newArray = NSMutableArray()
    let newDict = NSMutableDictionary()
    lazy var urlString: String =
        {
           
            return "https://api.androidhive.info/contacts/"
            
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        serviceCall()
      
    }
    func serviceCall()
    {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                self.personInformation = jsonObj!.value(forKey: "contacts")
                    as! NSArray
                
                
                OperationQueue.main.addOperation({
                    
                    self.createDatabase()
                    
                })
            }
        }).resume()
        
        
        
    }
    func createDatabase()
    {
        
        let fileManager = FileManager.default
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        fileURL = documentsPath.appendingPathComponent("jsonResult.db")! as NSURL
        print(fileURL)
        
        
        if !fileManager.fileExists(atPath: fileURL.path!) {
            
            let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTSDB (ID TEXT, NAME TEXT, EMAIL TEXT, ADDRESS TEXT, GENDER TEXT, PHONE TEXT)"
                
                
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                contactDB.close()
                self.insertTodb()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
        fetchFromDb()
    }
    func insertTodb()
    {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)


        if contactDB.open() {
            for person in personInformation
            {
            let personDict = person as! NSDictionary
                print(personDict.value(forKey: "name"))
                let idValue = personDict.value(forKey: "id")
                let nameValue = personDict.value(forKey: "name")
                let emailValue = personDict.value(forKey: "email")
                let addressValue = personDict.value(forKey: "address")
                let genderValue = personDict.value(forKey: "gender")
                let phnDict = personDict.value(forKey: "phone") as! NSDictionary
                let phnValue =  phnDict.value(forKey: "mobile") as? String
            let insertSQL = "INSERT INTO CONTACTSDB (id, name, email,  address, gender,phone) VALUES ('\(idValue!)', '\(nameValue!)', '\(emailValue!)', '\(addressValue!)', '\(genderValue!)', '\(phnValue!)')"
            
            
            
            var result = Bool()

            do {
                try contactDB.executeUpdate(insertSQL, values: nil)

            }
            catch {
                print("Could not create table.")
                print(error.localizedDescription)
            }
 contactDB.commit()
                
            }
           
           contactDB.close()

        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    func fetchFromDb()
    {
        let contactDB = FMDatabase(path: fileURL.absoluteString as! String)
        if contactDB.open() {
            
            
            let query = "select * from CONTACTSDB"
            
            do {
                print(contactDB)
                let results = try contactDB.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    print(results.string(forColumn: "ID")!)
                  
                    
                    let nameValue = results.string(forColumn: "name")
                        print(nameValue)
                    newDict.setValue(results.string(forColumn: "id")!, forKey: "id")
                    newDict.setValue(results.string(forColumn: "name")!, forKey: "name")
                    newDict.setValue(results.string(forColumn: "email")!, forKey: "email")
                    newDict.setValue(results.string(forColumn: "address")!, forKey: "address")
                    newDict.setValue(results.string(forColumn: "gender")!, forKey: "gender")
                    newDict.setValue(results.string(forColumn: "phone")!, forKey: "phone")
                    newArray.add(newDict)
                    print(newDict)
                    print(newArray)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            contactDB.close()
            print(newArray.count)
            listTableView.reloadData()
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(newArray.count)
        return newArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "listId", for: indexPath) as! ListTableViewCell
        let dict = newArray.object(at: indexPath.row)as! NSDictionary
        print(dict.value(forKey: "id"))
        cell.idText.text = dict.value(forKey: "id") as! String
        cell.nameText.text = dict.value(forKey: "name") as! String
        cell.emailText.text = dict.value(forKey: "email") as! String
        cell.addressText.text = dict.value(forKey: "address") as! String as! String
        cell.genderText.text = dict.value(forKey: "gender") as! String
        cell.phoneText.text = dict.value(forKey: "phone") as! String
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
