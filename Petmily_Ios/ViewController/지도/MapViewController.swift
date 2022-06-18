//
//  MapViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit
import CoreLocation
import NMapsMap

class MapViewController: UIViewController{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var PlaceButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    var locationManager = CLLocationManager() // 위치 권한
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSet()
        mapSet()
        authoritySet()
    }
}

extension MapViewController: CLLocationManagerDelegate{// 위치 권한 받기
    func authoritySet(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
        locationManager.requestWhenInUseAuthorization() // 위치 서비스 권한 팝업
        
        if CLLocationManager.locationServicesEnabled(){
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
}

extension MapViewController{
    func layoutSet(){
        PlaceButton.layer.cornerRadius = PlaceButton.frame.height/2
        PlaceButton.clipsToBounds = true
        searchButton.layer.cornerRadius = PlaceButton.frame.height/2
        searchButton.clipsToBounds = true
    }
    
    func mapSet(){
        naverMapView.showLocationButton = true
    }
}

extension MapViewController{
    @IBAction func searchPlace(_ sender: Any) {
        
    }
    
    @IBAction func showPlace(_ sender: Any) {
        performSegue(withIdentifier: "showPlace", sender: self)
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
