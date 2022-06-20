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
    
    var places = [Document]()
    
    //MARK: - 변수
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var PlaceButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locattionButton: NMFLocationButton!
    
    var locationManager = CLLocationManager() // 위치 권한
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
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
        searchBar.searchTextField.backgroundColor = .white
    }
    
    func mapSet(){
        naverMapView.showLocationButton = false
        locattionButton.mapView = naverMapView.mapView
    }
    
    func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchbarAlert(){
        let alert = UIAlertController(title:"검색어가 없습니다.",
            message: "검색창에 장소를 입력해주세요",
            preferredStyle: UIAlertController.Style.alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert,animated: true,completion: nil)
    }
}

//MARK: - button 이벤트
extension MapViewController{
    @IBAction func searchPlace(_ sender: Any) {
        let searchText = searchBar.text
        
        guard searchText != "" else {
            searchbarAlert()
            return
        }
        getPlace(searchText!)
        collectionView.isHidden = false
        dismissKeyboard()
    }
    
    @IBAction func showPlace(_ sender: Any) {
        performSegue(withIdentifier: "showPlace", sender: self)
    }
}

//MARK: - keyboard
extension MapViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        
        guard searchText != "" else {
            searchbarAlert()
            return
        }
        getPlace(searchText!)
        collectionView.isHidden = false
        dismissKeyboard()
    }
}


//MARK: - kakao api : GET
extension MapViewController{
    func getPlace(_ searchText: String){
        AF.request(url,
                   method: .get,
                   parameters: ["query":searchText],
                   encoding: URLEncoding.default,
                   headers: headers
        )
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(Response.self, from: jsonData)
                    self.places = json.documents
                    self.collectionView.reloadData()
                    print(json.documents) // 데이터 확인
                } catch(let error){
                    print("catch error : \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        })
    }
}

extension MapViewController :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.places.count)
        return self.places.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as? MapCollectionViewCell else {
            return UICollectionViewCell()
        }
        let place = self.places[indexPath.row]
        cell.updateUI(place: place)
    
//        cell.stbackView.layer.shadowColor = UIColor.black.cgColor
//        cell.stbackView.layer.shadowOpacity = 0.5
//        cell.stbackView.layer.shadowRadius = 10
//        cell.stbackView.layer.masksToBounds = false
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //셀사이즈
        let width = collectionView.bounds.width
        let height :CGFloat = 130
        return CGSize(width: width , height: height)
    }
}
