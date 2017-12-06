//
//  PhotoTableViewCell.swift
//  CoreDataJsonSample
//
//  Created by Vidya R on 01/01/18.
//  Copyright © 2018 Vidya R. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var PhnLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
