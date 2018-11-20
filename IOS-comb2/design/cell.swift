//
//  cell.swift
//  design
//
//  Created by Tonya on 07/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//
import UIKit


class Cell: UITableViewCell {
    
    
    @IBOutlet weak var arrivetime: UILabel!
    @IBOutlet weak var arriveplace: UILabel!
    @IBOutlet weak var timeonfees: UILabel!
    
    @IBOutlet weak var arriveTimeMin: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
