//
//  homeCV.swift
//  FaceHealth
//
//  Created by Tianchen Wang on 2017-12-02.
//  Copyright © 2017 Tianchen Wang. All rights reserved.
//

import UIKit
import ResearchKit
var loadedOnce = false

class homeCV: UIViewController, ORKTaskViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = true;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !loadedOnce{
            loadedOnce = true
            let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }
    }
}
