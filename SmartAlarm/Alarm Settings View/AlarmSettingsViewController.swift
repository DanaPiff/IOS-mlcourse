//
//  SecondViewController.swift
//  design
//
//  Created by Tonya on 18/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit
import UserNotifications

protocol  AlarmSettingsDelegate {
    func addAlarm(alarmCoreData: AlarmCoreData)
    func changeAlarm(alarm: Alarm, indexPath: IndexPath)
}

class AlarmSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let hoursarr = Array(0...23)
    let minutsarr = Array(0...59)
    let songName = "s.caf"
    
    let settingsCellIdentifier = "secondCell"
    
    var delegate: AlarmSettingsDelegate?
    
    var alarm: Alarm?
    var indexPathInAlarmsView: IndexPath?
    var selectedRowIndexPath: IndexPath?
    var isCreationOfNewAlarm = false
    
    //чтобы определить, открываем карту выбора места прибытия или отправки
    var openArrivalMap: Bool?
    
    let listForSecond = [
        "Установить время на сборы",
        "Откуда поедете",
        "Куда поедете",
        "На чем поедете",
    ]
    
    @IBOutlet weak var hours: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        if alarm == nil {
            alarm = Alarm()
            isCreationOfNewAlarm = true
        }
        TableView.register(UINib.init(nibName: "AlarmSettingsCell", bundle: nil), forCellReuseIdentifier: settingsCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath) as! AlarmSettingsCell
        cell.LabelForSecond.text = String(listForSecond[indexPath.row])
        if let alarmm = alarm {
            fillCell(alarm: alarmm, row: indexPath.row, cell: cell)
        }
        return cell
    }
    
    func fillCell(alarm: Alarm, row: Int, cell: AlarmSettingsCell) {
        switch row {
        case 0:
            cell.rightLabel.text = String(alarm.timeForFees) + " min"
        case 1:
            cell.rightLabel.text = alarm.getupPlace
        case 2:
            cell.rightLabel.text = alarm.arrivingPlace
        case 3:
            switch alarm.transport {
            case TransportType.auto:
                 cell.rightLabel.text = "Car"
            case TransportType.bicycle:
                cell.rightLabel.text = "Bicycle"
            case TransportType.publicTransport:
                cell.rightLabel.text = "Public transport"
            case TransportType.onFoot:
                cell.rightLabel.text = "On foot"
            }
        default:
            return
        }
    }
    
    @IBAction func save(_ sender: Any) {
         if isCreationOfNewAlarm {
            let managedObject = AlarmCoreData()
            managedObject.fill(from: alarm!)
            CoreDataManager.instance.saveContext()
            delegate?.addAlarm(alarmCoreData: managedObject)
        } else {
            if let previousViewIndexPath = indexPathInAlarmsView, let updatedAlarm = alarm {
                delegate?.changeAlarm(alarm: updatedAlarm, indexPath: previousViewIndexPath)
            }
        }
        setPush(arrivingLatitude: alarm!.arrivingLatitude,
                arrivingLongtitude: alarm!.arrivingLongtitude,
                getupLatitude: alarm!.getupLatitude,
                getupLongtitude: alarm!.getupLongtitude,
                timeForPacking: alarm!.timeForFees)
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(hoursarr[row]);
        } else {
            return String(minutsarr[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            let titleData = String(hoursarr[row])
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
            return myTitle
        }
        
        let titleData = String(minutsarr[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            alarm?.arrivingTimeHours = hoursarr[row]
        } else {
            alarm?.arrivingTimeMin = minutsarr[row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let alarm = alarm {
            pickerView.selectRow(alarm.arrivingTimeHours, inComponent: 0, animated: true)
            pickerView.selectRow(alarm.arrivingTimeMin, inComponent: 1, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursarr.count
        } else {
            return minutsarr.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForSecond.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRowIndexPath = indexPath
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toFees", sender: self)
            return
        }
        if indexPath.row == 1 {
            openArrivalMap = false
            performSegue(withIdentifier: "toMapView", sender: self)
            return
        }
        if indexPath.row == 2 {
            openArrivalMap = true
            performSegue(withIdentifier: "toMapView", sender: self)
            return
        }
        if indexPath.row == 3 {
            performSegue(withIdentifier: "toSelectTransportView", sender: self)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.delegate = self
            destinationVC.alarm = alarm!
            destinationVC.isArrivalMap = openArrivalMap!
            return
        }
        if segue.identifier == "toSelectTransportView" {
            let destinationVC = segue.destination as! TransportViewController
            destinationVC.delegate = self
            return
        }
        if segue.identifier == "toFees" {
            let feesVC = segue.destination as! FeesController
            feesVC.delegate = self
            return
        }
    }
    
    func setPush(arrivingLatitude: Double, arrivingLongtitude: Double,
                 getupLatitude: Double, getupLongtitude: Double, timeForPacking: Int) {
    
        print("setPush()")
        //callback, который запустится после того, как придет ответ
        let callback = { (time: Int) -> Void in
            if time == -1 {
                // у написано так, что в случае любой ошибки вызовется
                // этот колббек с парметром -1. Можно изменить
                print("Something goes wrong with api")
            }
            print("Duration for this journey (with time for packing) is: \(time) (seconds)")
            //нужно, чтобы минимальный интервал между пушами был 60 сек
            //let parsedTime = time < 60 ? 60 : time
            let date = self.getDateForPush(secondsForRoad: time,
                                           tagetHour: self.alarm!.arrivingTimeHours,
                                           targetMinute: self.alarm!.arrivingTimeMin,
                                           timeForPacking: timeForPacking)
            self.firePush(at: date)
        }
        
        let travelManager = TravelManager(callback: callback)
        let myAdress = String(getupLatitude) + "," + String(getupLongtitude)
        let secondAdress = String(arrivingLatitude) + "," + String(arrivingLongtitude)
   
        //внутри этого метода выполнится коллбэк, объявленный ранее
        travelManager.getTravelTime(origin: myAdress, destination: secondAdress, mode: TravelModes.transit, additionalMinutes: timeForPacking)
    }
    
    
    //перевод полученных из апи секунд + времени на сборы в нужный формат
    func getDateForPush(secondsForRoad: Int, tagetHour: Int, targetMinute: Int, timeForPacking: Int) -> DateComponents {
        let nowDate = Date()
        let nowCalendar = Calendar.current
        
        var targetDateComponents = DateComponents()
        targetDateComponents.year = nowCalendar.component(.year, from: nowDate)
        targetDateComponents.month = nowCalendar.component(.month, from: nowDate)
        targetDateComponents.day = nowCalendar.component(.day, from: nowDate)
        targetDateComponents.hour = tagetHour
        targetDateComponents.minute = targetMinute
        let targetDate = nowCalendar.date(from: targetDateComponents)
    
        let secondsForFeesAndRoad = secondsForRoad + timeForPacking * 60
        var getupDateComponents = DateComponents()
        getupDateComponents.second = -1 * secondsForFeesAndRoad
        
        print("secondsForFeesAndRoad = \(secondsForFeesAndRoad)")
        let resultDate = Calendar.current.date(byAdding: getupDateComponents, to: targetDate!)
        
        let unitFlags:Set<Calendar.Component> = [
            .hour, .day, .month,
            .year,.minute,.hour,.second,
            .calendar]
        let resDateComponents = Calendar.current.dateComponents(unitFlags, from: resultDate!)
        print("GET UP TIME IS:")
        print("day = \(resDateComponents.day!), hour = \(resDateComponents.hour!), minute = \(resDateComponents.minute!)")
        return resDateComponents
    }
    
    //ставим пуш на нужное время
    func firePush(at date: DateComponents?) {
        guard let parsedDate = date else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body = "Please stand up, please stand up"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: songName))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: parsedDate, repeats: true)
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension AlarmSettingsViewController: MapViewControllerDelegate {
    func changeArrivalСoordinates(data: String, alarm: Alarm) {
        self.alarm?.arrivingPlace = data
        self.alarm?.arrivingLongtitude = alarm.arrivingLongtitude
        self.alarm?.arrivingLatitude = alarm.arrivingLatitude
        self.TableView.reloadRows(at: [selectedRowIndexPath!], with: .none)
    }
    
    func changeDispatchСoordinates(data: String, alarm: Alarm) {
        self.alarm?.getupPlace = data
        self.alarm?.getupLongtitude = alarm.getupLongtitude
        self.alarm?.getupLatitude = alarm.getupLatitude
        self.TableView.reloadRows(at: [selectedRowIndexPath!], with: .none)
    }
}

extension AlarmSettingsViewController: FeesControllerDelegate {
    func saveTime(minutes: Int) {
         self.alarm?.timeForFees = minutes
         self.TableView.reloadRows(at: [selectedRowIndexPath!], with: .none)
    }
}

extension AlarmSettingsViewController: TransportViewControllerDelegate {
    func changeTransport(transport: TransportType) {
        self.alarm?.transport = transport
        self.TableView.reloadRows(at: [selectedRowIndexPath!], with: .none)
    }
}

