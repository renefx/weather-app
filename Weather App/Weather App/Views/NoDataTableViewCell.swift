//
//  NoDataTableViewCell.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
