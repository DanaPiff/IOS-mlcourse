//
//  TransportViewController.swift
//  design
//
//  Created by Dana on 10.12.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

protocol choseTransport {
    func recivieData(data: String )
}

class TransportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate:choseTransport!
    

    let transportList = [
        "Автомобиль",
        "Общественный транспорт",
        "Велосипед",
        "Пешком",
        ]
    
    var choseTrans = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = String(transportList[indexPath.row])
        cell.textLabel?.textColor = UIColor.orange
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            choseTrans = transportList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func CompleteButton(_ sender: Any) {
        print(choseTrans)
        delegate?.recivieData(data: choseTrans)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
 

}
