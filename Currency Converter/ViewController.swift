//
//  ViewController.swift
//  Currency Converter
//
//  Created by Lauren Banawa on 4/29/20.
//  Copyright © 2020 Lauren Banawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRatesClicked(_ sender: Any) {
        
        // STEPS:
        // 1) Request & Session
        // 2) Response & Data
        // 3) Parsing & JSON Serialization
        
       // 1)
        // since url is http (not secure) -- go into Info.plist, add App Transport Security Settings, then add Allow Arbitrary Loads and change the NO to YES
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=8276b2059e608cf3a1e5f676268b3984")
        
        // create a session -- urlsession gets the data and manages transferring tasks with data in a specified network
        // adding the .shared makes sure that it keeps the same session instance (singleton) even with multiple requests
        let session = URLSession.shared
        
        // completion handler defines what will happen when we start the task
        // the structure in the tast variable is called "Closure"
        let task = session.dataTask(with: url!) { (data, response, error) in
            // if there is an error, return an alert with a message that is taken from the localized description of the error
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                // button to allow user to close the alert message
                let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton) // add the button as an action to the alert
                self.present(alert, animated: true, completion: nil) // allow application to present the alert
            } else {
                // 2)
                // if you do have data then go ahead and present the data
                if data != nil {
                    
                    do {
                    // convert the JSON format into strings, booleans, integers and/ or doubles
                    // mutableContainers allows us to work with arrays and dictionaries
                    let jsonResponse  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any> // <String, Any> is the format that the data is in, EX: "USD": 1.005
                        
                        // ASYNC -- means does not have to be synchronized, can do multiple things at once
                        // need a dictionary format to be able to get any piece of data from the dictionary
                            // this is why jsonResponse is force casted as a Dictionary
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text  = "CAD: \(cad)"
                                }
                                
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text  = "CHF: \(chf)"
                                }
                                
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text  = "GBP: \(gbp)"
                                }
                                
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text  = "JPY: \(jpy)"
                                }
                                
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text  = "USD: \(usd)"
                                }
                                
                                if let Turkish = rates["TRY"] as? Double {
                                    self.tryLabel.text  = "TRY: \(Turkish)"
                                }
                                
                            }
                        }
                        
                        
                    } catch {
                        print("error")
                    }
                    
                }
            }
        }
        
        // use .resume to start the task after we create it
        task.resume()
        
    }
    
}

