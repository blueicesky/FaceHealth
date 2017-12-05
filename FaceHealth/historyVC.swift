//
//  historyVC.swift
//  FaceHealth
//
//  Created by Tianchen Wang on 2017-12-01.
//  Copyright © 2017 Tianchen Wang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

struct historyStruct{
    var date = String()
    var image = UIImage()
    var health = String()
    var stroke = Int()
}

class historyVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var ref: DatabaseReference!
    var postArray = [historyStruct]()
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postArray = [historyStruct]()
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let val = snapshot.value as? Dictionary<String,AnyObject>{
                for (k,v) in val{
                    print("HIIIII")
                    var historyOne = historyStruct()
                    if let val2 = v as? Dictionary<String,AnyObject>{
                        for (x,y) in val2{
                            if x == "Date"{
                                historyOne.date = y as! String
                            }else if x == "Image"{
                                let dataDecoded : Data = Data(base64Encoded: y as! String, options: .ignoreUnknownCharacters)!
                                let decodedimage = UIImage(data: dataDecoded)
                                historyOne.image = decodedimage!
                            }else if x == "Health"{
                                if let vzz = y as? String{
                                    historyOne.health = vzz
                                }
                            }else if x == "Stroke"{
                                if let vzzz = y as? Int{
                                    historyOne.stroke = vzzz
                                }
                            }
                        }
                    }
                    self.postArray.append(historyOne)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! historyTVC
        cell.photoImg.image = self.postArray[indexPath.row].image
        cell.dateLabel.text = self.postArray[indexPath.row].date
        if self.postArray[indexPath.row].health == "Healthy"{
            cell.majorLabel.text = "Healthy"
            cell.statusInd.backgroundColor = UIColor.green
        }else{
            cell.majorLabel.text = "Unhealthy"
            cell.statusInd.backgroundColor = UIColor.red
        }
        if self.postArray[indexPath.row].stroke == 1{
            cell.majorLabel.text = cell.majorLabel.text! + " With Chance of Stroke"
        }
        print(postArray[indexPath.row].health)
        return cell
    }
    

}
