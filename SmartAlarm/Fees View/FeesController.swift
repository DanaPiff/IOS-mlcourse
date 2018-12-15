//
//  FeesController.swift
//  design
//
//  Created by Tonya on 09/12/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

protocol FeesControllerDelegate {
    func saveTime(minutes: Int)
}

class FeesController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var FeesTime: UIPickerView!
    var delegate: FeesControllerDelegate?
    var timeForFees: Int = 0
    let time = Array(0...120)
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time.count
    }
    
    @IBAction func SaveFeesTime(_ sender: Any) {
        delegate?.saveTime(minutes: timeForFees)
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(time[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = String(time[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeForFees = time[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FeesTime.delegate = self
        FeesTime.dataSource = self
    }
}
