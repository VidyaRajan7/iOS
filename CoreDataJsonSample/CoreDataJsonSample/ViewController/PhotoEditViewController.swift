//
//  PhotoEditViewController.swift
//  CoreDataJsonSample
//
//  Created by Vidya R on 06/12/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//

import UIKit

class PhotoEditViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var gmailText: UITextField!
    @IBOutlet weak var gender: UITextField!
    var fullArray = NSArray()
    var indexNumber = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fullArray.count != 0{
            let nsMutableArrayObject = fullArray.mutableCopy() as! NSMutableArray
            let selectedDict = nsMutableArrayObject.object(at: indexNumber) as! NSDictionary
            print(selectedDict.value(forKey: "name") as! String)
            nameText.text = selectedDict.value(forKey: "name") as? String
            gmailText.text = selectedDict.value(forKey: "email") as? String
            gender.text = selectedDict.value(forKey: "gender") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveUpdatedData(_ sender: UIButton)
    {
        
        if fullArray.count != 0{
            let nsMutableArrayObject = fullArray.mutableCopy() as! NSMutableArray
            let selectedDict = nsMutableArrayObject.object(at: indexNumber) as! NSDictionary
            print(selectedDict)
            selectedDict.setValue(nameText.text, forKey: "name") 
            selectedDict.setValue(gmailText.text, forKey: "email")
            selectedDict.setValue(gender.text, forKey: "gender")
           print(selectedDict)
        }
        
        
        
        
    }
    @IBAction func backAction(_ sender: UIButton)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
}
