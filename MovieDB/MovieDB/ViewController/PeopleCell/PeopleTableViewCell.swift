//
//  PeopleTableViewCell.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 02/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
