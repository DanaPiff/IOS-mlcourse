//
//  File.swift
//  design
//
//  Created by Tonya on 14/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation

import Foundation
import UIKit


struct Alarm {
    
    var arrivingplace = "Бауманка"
    var arrivingtimehours = 13
    var arrivingtimemin = 40
    var timeforfees = 40
    var getuptimehours = 0
    var getuptimemin = 0
    var getupplace = ""
}

extension Alarm {
    
    init?(dict: NSDictionary) {
        guard
            let arrivingplace = dict["arrivingplace"] as? String,
            let arrivingtimehours = dict["arrivingtimehours"] as? Int,
            let arrivingtimemin = dict["arrivingtimemin"] as? Int,
            let timeforfees = dict["timeforfees"] as? Int,
            let getuptimehours = dict["getuptimehours"] as? Int,
            let getuptimemin = dict["getuptimemin"] as? Int,
            let getupplace = dict["getupplace"] as? String
            else { return nil }
        
        self.arrivingplace = arrivingplace
        self.arrivingtimehours = arrivingtimehours
        self.arrivingtimemin = arrivingtimemin
        self.timeforfees = timeforfees
        self.getuptimehours = getuptimehours
        self.getuptimemin = getuptimemin
        self.getupplace = getupplace
    }
}
