//
//  MapViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit
import CoreLocation
import NMapsMap
import Alamofire

class MapViewController: UIViewController{
    //MARK: - Kakao api
    let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    let headers : HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
        "Authorization" : "KakaoAK 43d7c7d5953cc05cfe4479fb034163e0"
    ]
    
    //MARK: - 변수
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
//MARK: - 위치 권한 받기
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
//MARK: - 레이아웃 수정
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

//MARK: - button 이벤트
extension MapViewController{
    @IBAction func searchPlace(_ sender: Any) {
        getPlace()
    }
    
    @IBAction func showPlace(_ sender: Any) {
        performSegue(withIdentifier: "showPlace", sender: self)
    }
}
//MARK: - kakao api : GET
extension MapViewController{
    func getPlace(){
        AF.request(url,
                   method: .get,
                   parameters: ["query":searchBar.text ?? ""],
                   encoding: URLEncoding.default,
                   headers: headers
        )
        .validate()
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(Response.self, from: jsonData)
            
                    print(json.documents)
                } catch(let error){
                    print("catch error : \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        })
    }
}
