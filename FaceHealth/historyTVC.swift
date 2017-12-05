//
//  historyTVC.swift
//  FaceHealth
//
//  Created by Tianchen Wang on 2017-12-01.
//  Copyright © 2017 Tianchen Wang. All rights reserved.
//

import UIKit

class historyTVC: UITableViewCell {

    @IBOutlet weak var statusInd: UIImageView!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
