//
//  ForecastTableViewCell.swift
//  WeatherAppPage
//
//  Created by Peter Gartner on 2016-12-02.
//  Copyright © 2016 Peter Gartner. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
