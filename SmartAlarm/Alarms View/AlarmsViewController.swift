//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var alarms = [Alarm]()
    var selectedAlarm: Alarm?
    
    var alarmsCoreData = [AlarmCoreData]()
    var selectedAlarmCoreData: AlarmCoreData?

    var selectedIndexPath: IndexPath?
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "AlarmCoreData", keyForSort: "id")
    
    let cellIdentifier = "alarmcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.fetchedResultsController.performFetch()
            alarmsCoreData = self.fetchedResultsController.fetchedObjects as! [AlarmCoreData]
        } catch {
            print("ERROR WITH try self.fetchedResultsController.performFetch()")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "AlarmCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //изменение будильника
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlarmCoreData = alarmsCoreData[indexPath.row]
        selectedAlarm = selectedAlarmCoreData?.makeAlarm()
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    @IBAction func createNewAlarm(_ sender: UIBarButtonItem) {
        selectedAlarm = nil
        performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecond" {
            let settigsViewController = segue.destination as! AlarmSettingsViewController
            //to do поставить кор дату
            settigsViewController.alarm = selectedAlarm
            settigsViewController.indexPathInAlarmsView = selectedIndexPath
            settigsViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlarmCell
        cell.fill(alarm: alarmsCoreData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}

extension AlarmsViewController: AlarmSettingsDelegate {
    func addAlarm(alarmCoreData: AlarmCoreData)  {
        alarmsCoreData.append(alarmCoreData)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func changeAlarm(alarm: Alarm, indexPath: IndexPath) {
        let alarmCoreData = AlarmCoreData()
        alarmCoreData.fill(from: alarm)
        alarmsCoreData[indexPath.row] = alarmCoreData
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
