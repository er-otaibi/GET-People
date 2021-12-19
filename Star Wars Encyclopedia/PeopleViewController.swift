//
//  ViewController.swift
//  Star Wars Encyclopedia
//
//  Created by Mac on 15/05/1443 AH.
//

import UIKit

class PeopleViewController: UITableViewController {
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gatData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the count of people in our data array
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell" , for: indexPath)
        // set the default cell label to the corresponding element in the people array
        cell.textLabel?.text = names[indexPath.row]
        // return the cell so that it can be rendered
        return cell
        
    }
    
    func gatData() {
        
        
        for i in 1...9 {
            
            // specify the url that we will be sending the GET request to
            
            let url = URL(string: "https://swapi.dev/api/people/?page=\(i)&format=json")
            // create a URLSession to handle the request tasks
            let session = URLSession.shared
            // create a "data task" to make the request and run completion handler
            let task = session.dataTask(with: url!, completionHandler: {
                // see: Swift closure expression syntax
                data, response, error in
                // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
                // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
                do {
                    // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        //print(jsonResult)
                        
                        if let results = jsonResult["results"] {
                            // coercing the results object as an NSArray and then storing that in resultsArray
                            let resultsArray = results as! NSArray
                            
                            
                            // now we can run NSArray methods like count and firstObject
                            for i in resultsArray {
                                
                                if let name: String = (i as! NSDictionary).value(forKey:"name") as? String {
                                    self.names.append(name)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                            print(self.names)
                        }
                    }
                } catch {
                    print(error)
                }
            })
            // execute the task and then wait for the response
            // to run the completion handler. This is async!
            task.resume()
        }
        
    }
}

