//
//  MapViewController.swift
//  design
//
//  Created by Dana on 10.12.2018.
//  Copyright © 2018 Tonya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func changeArrivalСoordinates(data: String, alarm: Alarm)
    func changeDispatchСoordinates(data: String, alarm: Alarm)
}

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    var delegate:MapViewControllerDelegate?
    var placeName: String?
    var isArrivalMap = false
    var alarm: Alarm?
    
    let geocoder = CLGeocoder()
    var adress = ""
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        myMapView.setRegion(region, animated: true)
        
        self.myMapView.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    
    @objc func action (gestureRecognizer: UIGestureRecognizer) {
        
        self.myMapView.removeAnnotations(myMapView.annotations)
        let touchPoint = gestureRecognizer.location(in: myMapView)
        let newCoords = myMapView.convert(touchPoint, toCoordinateFrom: myMapView)
        
        geocoderLocation(newLocation: CLLocation(latitude: newCoords.latitude, longitude: newCoords.longitude))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoords
        annotation.title = adress
        
        myMapView.addAnnotation(annotation)
        
        if self.isArrivalMap {
            self.alarm?.arrivingLongtitude = newCoords.longitude
            self.alarm?.arrivingLatitude = newCoords.latitude
            
        } else {
            self.alarm?.getupLongtitude = newCoords.longitude
            self.alarm?.getupLatitude = newCoords.latitude
            
        }
        
        self.placeName = annotation.title
    }
    
    func geocoderLocation(newLocation: CLLocation) {
        var dir=""
        geocoder.reverseGeocodeLocation(newLocation){(placemarks, error) in
            if error == nil {
                dir = "No directory"
            }
            if let placemark = placemarks?.last {
                dir = self.stringFromPlacemark(placemark: placemark)
            }
            self.adress = dir
            
        }
    }
    
    func stringFromPlacemark (placemark:CLPlacemark) -> String{
        var line = ""
        if let p = placemark.thoroughfare {
            line += p + ", "
        }
        if  let p = placemark.subThoroughfare {
            line += p + "  "
        }
        if let p = placemark.locality {
            line += "(" + p + ")"
        }
        return line
    }
    
    @IBOutlet weak var buttonOk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonOk.layer.cornerRadius = 30
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.action(gestureRecognizer:)))
        myMapView.addGestureRecognizer(tapGesture)
    }
    
  
    
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController (searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print ("MapView: response == nil")
            } else {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                if self.isArrivalMap {
                    self.alarm?.arrivingLongtitude = longitude ?? 0
                    self.alarm?.arrivingLatitude = latitude ?? 0
                } else {
                    self.alarm?.getupLongtitude = longitude ?? 0
                    self.alarm?.getupLatitude = latitude ?? 0
                }
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate,span: span)
                self.myMapView.setRegion(region, animated: true)
                self.placeName = annotation.title
            }
            
        }
    }
    
    @IBAction func buttonOk(_ sender: UIButton) {
        guard let parsedPlaceName = placeName else {
            print("MapViwController. ParsedPlaceName is nil")
            self.navigationController?.popViewController(animated: true)
            return
        }
        if isArrivalMap {
            delegate?.changeArrivalСoordinates(data: parsedPlaceName, alarm: alarm!)
        } else {
            delegate?.changeDispatchСoordinates(data: parsedPlaceName, alarm: alarm!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        pin.pinTintColor = UIColor.orange
        return pin
    }
}

