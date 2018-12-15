//
//  TransportViewController.swift
//  design
//
//  Created by Dana on 10.12.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

protocol TransportViewControllerDelegate {
    func changeTransport(transport: TransportType)
}

class TransportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: TransportViewControllerDelegate?
    
    var chosenTransport = TransportType.auto
    var selectedIndexPath: IndexPath?
    
    let transportDict = [
        "Автомобиль": TransportType.auto,
        "Общественный транспорт": TransportType.publicTransport,
        "Велосипед": TransportType.bicycle,
        "Пешком": TransportType.onFoot
    ]
    
    var dictKeys: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        dictKeys = Array(transportDict.keys)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictKeys!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let value = dictKeys![indexPath.row]
        cell.textLabel?.text = value
        cell.textLabel?.textColor = UIColor.orange
        cell.selectionStyle = .none
        
        if transportDict[value]! == chosenTransport {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            return
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .none
        selectedIndexPath = indexPath
        let value = dictKeys![indexPath.row]
        chosenTransport = transportDict[value]!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.changeTransport(transport: chosenTransport)
    }
}
