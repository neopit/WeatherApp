//
//  FindTableViewCell.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import UIKit

class FindTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
