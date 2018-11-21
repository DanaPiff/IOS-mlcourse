//
//  SecondViewController.swift
//  design
//
//  Created by Tonya on 18/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var DataPicker: UIDatePicker!
    
    @IBOutlet weak var PrepareTimeTextField: UITextField!
    
    @IBAction func OnTouchUpInside(_ sender: Any) {
          //ViewControllsHolder.sharedInstance.MainTableView.add
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ViewControllsHolder.sharedInstance.DataPicker = DataPicker;
        ViewControllsHolder.sharedInstance.PrepareTimeTextField = PrepareTimeTextField;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
