//
//  PhotoViewController.swift
//  CoreDataJsonSample
//
//  Created by Vidya R on 23/11/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit
import CoreData

class PhotoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
     @IBOutlet weak var tableViewControl: UITableView!
    var personInformation = NSArray()
    lazy var endPoint: String =
        {
            //return “https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
            return "https://api.androidhive.info/contacts/"
            
    }()
    @IBOutlet weak var viewsamle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let isCacheAvailable = UserDefaults.standard.bool(forKey: "isCacheAvailable")
        if isCacheAvailable
        {
            fetchFromCoreData()
        }
        else
        {
            serviceCall()
            UserDefaults.standard.set(true, forKey: "isCacheAvailable")
        }
        
        tableViewControl.delegate = self
        
        
    }
    func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func serviceCall()
    {
         let url = URL(string: endPoint)
         
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    self.personInformation = jsonObj!.value(forKey: "contacts")
                        as! NSArray

                    
                    OperationQueue.main.addOperation({
                        
                        self.saveValuesToCoreData(coreDataArray: self.personInformation)
                    })
                }
            }).resume()
        
            
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func saveValuesToCoreData(coreDataArray : NSArray)
    {
        print(personInformation)
        
        
        let viewContexObject = getContext()
        let personData = NSKeyedArchiver.archivedData(withRootObject: personInformation)
        
        //if let PhotoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: viewContexObject) as? Photo{
        let PhotoEntity =  NSEntityDescription.entity(forEntityName: "Photo",
                                                      in:viewContexObject)
            
        let device = NSManagedObject(entity: PhotoEntity!,
                                     insertInto: viewContexObject)
        
        
            device.setValue(personData, forKey: "photoInfo")
        
            do {
                try viewContexObject.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        
    fetchFromCoreData()
    }
    func fetchFromCoreData()
    {
        let viewContexObject = getContext()
       //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        do {
            let results =
                try viewContexObject.fetch(fetchRequest) as NSArray
            
            if results.count != 0 {
                
                for result  in results {
                    
                    let dataObject = (result as AnyObject).value(forKey: "photoInfo") as! NSData
                    
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: dataObject as Data)
                    let arrayObject = unarchiveObject
                    personInformation = arrayObject  as! NSArray
                }
                print(personInformation.count)
                tableViewControl.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return personInformation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! PhotoTableViewCell
        
        let personDict = personInformation.object(at: indexPath.row) as! NSDictionary
        cell.nameLabel.text = personDict.value(forKey: "name") as? String
        cell.emailText.text = personDict.value(forKey: "email") as? String
        cell.genderLabel.text = personDict.value(forKey: "gender") as? String
        let phnDict = personDict.value(forKey: "phone") as! NSDictionary
        cell.PhnLabel.text = phnDict.value(forKey: "mobile") as? String
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            let mutableArray = personInformation.mutableCopy() as! NSMutableArray
            
            let context = getContext()
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            do {
                let results =
                    try context.fetch(fetchRequest) as NSArray
                
                if results.count != 0 {
                   
                    for result  in results {
                        
                        let dataObject = (result as AnyObject).value(forKey: "photoInfo") as! NSData
                        
                        let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: dataObject as Data)
                        let arrayObject = unarchiveObject
                        personInformation = arrayObject  as! NSArray
                       
                        
                    }
                     mutableArray.removeObject(at: indexPath.row)
                    personInformation = mutableArray
                   
                    saveValuesToCoreData(coreDataArray: personInformation)
                   
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
         
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBord = UIStoryboard.init(name: "Main", bundle: nil)
        let nextViewController : PhotoEditViewController = storyBord.instantiateViewController(withIdentifier: "photoEditID") as! PhotoEditViewController
        nextViewController.fullArray = personInformation;
        nextViewController.indexNumber = indexPath.row
        self.present(nextViewController, animated: false, completion: nil)
    }
}
