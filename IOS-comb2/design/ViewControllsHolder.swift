//
//  DataShedulerManager.swift
//  design
//
//  Created by Dana on 19.11.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation
import UIKit

class ViewControllsHolder
{
    static let sharedInstance: ViewControllsHolder = {
        let instance = ViewControllsHolder()
        
        return instance
    }()
    
    weak var DataPicker: UIDatePicker!
    weak var PrepareTimeTextField: UITextField!
    weak var MainTableView: UITableView!
}
