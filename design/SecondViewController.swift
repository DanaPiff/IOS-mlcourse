//
//  SecondViewController.swift
//  design
//
//  Created by Tonya on 18/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var SecondTableView: UITableView!
    
    
    let listForSecond = [
        "Установить место прибытия",
        "Установить время прибытия",
        "Установить время на сборы",
        "Установить место подъема",
        "Поставить будильник!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondTableView.dataSource = self
        SecondTableView.delegate = self
        SecondTableView.register(UINib.init(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "secondCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForSecond.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! SecondTableViewCell
        cell.LabelForSecond.text = String(listForSecond[indexPath.row])
        return cell
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
