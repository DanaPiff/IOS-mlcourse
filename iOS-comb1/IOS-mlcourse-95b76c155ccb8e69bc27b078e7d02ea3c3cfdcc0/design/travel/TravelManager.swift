//
//  TravelManager.swift
//  design
//
//  Created by Dana on 19.11.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import Foundation

enum TravelModes: String {
    case driving = "driving"
    case walking = "walking"
    case bicycling = "bicycling"
    //общественный транспорт
    case transit = "transit"
}

class TravelManager {
    
    var callback: (_ time: Int) -> Void
    
    //не сильно палите его, а то с моей карты снимут деньги
    let apiKey = "AIzaSyAFAiCaawSxOSXjUxAFqsiMsZpgVWpq6g8"
    
    init(callback: @escaping (_ time: Int) -> Void) {
        self.callback = callback
    }
    
    func getTravelTime(origin: String, destination: String, mode: TravelModes = .driving, additionalMinutes: Int = 0) {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(mode)&key=\(apiKey)"
        
        guard let parsedUrl = URL(string: url) else {
            print("Bad url parameters")
            self.callback(-1)
            return
        }
        
        URLSession.shared.dataTask(with: parsedUrl) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.callback(-1)
                return
            }
            guard let data = data else {
                self.callback(-1)
                return
            }
            
            guard let journey = try? JSONDecoder().decode(Journey.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                self.callback(-1)
                return
            }
            
            guard let durationInSeconds = journey.routes.first?.legs.first?.duration.value else { return }
            //let minutes = self.convertSecsToMinutes(seconds: durationInSeconds)
            
            self.callback(durationInSeconds + additionalMinutes * 60)
            }.resume()
    }
}
