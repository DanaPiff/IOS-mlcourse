//
//  ViewController.swift
//  design
//
//  Created by Tonya on 06/11/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBAction func NewAlarm(_ sender: UIButton) {
            performSegue(withIdentifier: "toSecond", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let SecondVC = segue.destination as! SecondViewController
        SecondVC.DataDelegate = self
    }
    
    let songName = "s.caf"
    
    var alarms = [Alarm]()

    let list: [String: Any] = [
        "arrivingplace": "Бауманка",
        "arrivingtimehours": 15,
        "arrivingtimemin": 43   ,
        "timeforfees": 1,
        "getuptimehours": 12,
        "getuptimemin": 10,
        "getupplace": "home"
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as! Cell
        cell.arrivetime.text = String(alarms[indexPath.row].arrivingtimehours)
        cell.arriveplace.text = alarms[indexPath.row].arrivingplace
        cell.timeonfees.text = String(alarms[indexPath.row].timeforfees)
        cell.arriveTimeMin.text = String(alarms[indexPath.row].arrivingtimemin)
        return cell
    }
    
    func full(){
        guard let alarm = Alarm(dict: list as NSDictionary) else { return }
        alarms.append(alarm)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        full()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "cell", bundle: nil), forCellReuseIdentifier: "alarmcell")
        testTime()
        
    }
    
    func testTime() {
        //callback, который запустится после того, как придет ответ
        let callback = { (time: Int) -> Void in
            if time == -1 {
                // у написано так, что в случае любой ошибки вызовется
                // этот колббек с парметром -1. Можно изменить
                print("Something goes wrong")
            }
            print("Duration for this journey (with time for packing) is: \(time) (seconds)")
            //нужно, чтобы минимальный интервал между пушами был 60 сек
            let parsedTime = time < 60 ? 60 : time
            let date = self.getDateForPush(seconds: parsedTime)
            self.firePush(at: date)
        }
        
        let travelManager = TravelManager(callback: callback)
        let myAdress = "55.683494,37.528046"
        let secondAdress = "55.685939,37.532917"
        //время на сборы в минутах
        let timeForPacking = 2
        
        //внутри этого метода выполнится коллбэк, объявленный ранее
        travelManager.getTravelTime(origin: myAdress, destination: secondAdress, mode: TravelModes.transit, additionalMinutes: timeForPacking)
    }
    
    //перевод полученных из апи секунд + времени на сборы в нужный формат
    func getDateForPush(seconds: Int) -> DateComponents {
        let now = Date()
        let newDate =  Calendar.current.date(byAdding: .second, value: seconds, to: now)
        let unitFlags:Set<Calendar.Component> = [
            .hour, .day, .month,
            .year,.minute,.hour,.second,
            .calendar]
        let dateComponents = Calendar.current.dateComponents(unitFlags, from: newDate!)
        return dateComponents
    }
    
    //просто функция, которая вызовет пуш через минуту. Нам она не нужна
    @IBAction func touchPushButton(_ sender: UIButton) {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        //запускаем будильник через минуту
        var date = DateComponents()
        date.hour = hour
        date.minute = minutes + 1
        firePush(at: date)
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

extension ViewController: dataToFirst{
    func SaveData(list: Alarm)  {
        alarms.append(list)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
