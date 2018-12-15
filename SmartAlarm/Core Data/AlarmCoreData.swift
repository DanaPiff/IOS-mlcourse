//
//  AlarmCoreData.swift
//  SmartAlarm
//
//  Created by Андрей Бабков on 12/12/2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation
import CoreData

extension AlarmCoreData {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "AlarmCoreData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    func makeAlarm() -> Alarm {
        var alarm = Alarm()
        alarm.arrivingPlace = self.arrivingPlace ?? alarm.arrivingPlace
        
        alarm.arrivingTimeHours = Int(self.arrivingTimeHours)
        alarm.arrivingTimeMin = Int(self.arrivingTimeMin)
        alarm.timeForFees = Int(self.timeForFees)
        alarm.getupTimeHours = Int(getupTimeHours)
        alarm.getupTimeMin = Int(getupTimeMin)
        alarm.getupPlace = self.getupPlace ?? alarm.getupPlace
        
        if let transp = self.transport {
            switch transp {
            case "Car":
                alarm.transport = TransportType.auto
            case "Bicycle":
                alarm.transport = TransportType.auto
            case "Public transport":
                alarm.transport = TransportType.auto
            case "On foot":
               alarm.transport = TransportType.auto
            default:
                alarm.transport = TransportType.auto
            }
        } else {
            alarm.transport = TransportType.auto
        }
        
        alarm.isOn = self.isOn
        alarm.id = Int(self.id)
        alarm.arrivingLatitude = self.arrivingLatitude
        alarm.arrivingLongtitude = self.arrivingLongtitude
        alarm.getupLatitude = self.getupLatitude
        alarm.getupLongtitude = self.getupLongtitude
        return alarm
    }
    
    func fill(from alarm: Alarm) {
        id = Int16(alarm.id)
        arrivingPlace = alarm.arrivingPlace
        arrivingTimeHours = Int16(alarm.arrivingTimeHours)
        arrivingTimeMin = Int16(alarm.arrivingTimeMin)
        getupTimeHours = Int16(alarm.getupTimeHours)
        getupTimeMin = Int16(alarm.getupTimeMin)
        getupPlace = alarm.getupPlace
        timeForFees = Int16(alarm.timeForFees)
        
        isOn = alarm.isOn
        arrivingLatitude = alarm.arrivingLatitude
        arrivingLongtitude = alarm.arrivingLongtitude
        getupLatitude = alarm.getupLatitude
        getupLongtitude = alarm.getupLongtitude
        
        switch alarm.transport {
        case TransportType.auto:
            transport = "Car"
        case TransportType.bicycle:
             transport = "Bicycle"
        case TransportType.publicTransport:
             transport = "Public transport"
        case TransportType.onFoot:
             transport =  "On foot"
        }
    }
}
