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
import SafariServices

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
    @IBOutlet weak var naverMapView: NMFMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var markers =  [NMFMarker]()
    var locationManager = CLLocationManager() // 위치 권한
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        layoutSet()
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
        deleteMarkers()
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
        deleteMarkers()
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
                    let json = try JSONDecoder().decode(PlaceResponse.self, from: jsonData)
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

//MARK: - cell 구성하기
extension MapViewController :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //검색 결과 갯수
        print(self.places.count)
        return self.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //셀 구성
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as? MapCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let place = self.places[indexPath.row]
        print(place.placeName)
        
        updateCamera(place)
        cell.updateUI(place: place)
        updateMarker(place)
        
        cell.likePlaceButton.tag = indexPath.row
        cell.likePlaceButton.addTarget(self, action: #selector(likePlace(_:)), for: .touchUpInside)
        
        cell.sharePlaceButton.tag = indexPath.row
        cell.sharePlaceButton.addTarget(self, action: #selector(sharePlace(_:)), for: .touchUpInside)
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = self.places[indexPath.row]
        let Url = NSURL(string: place.placeURL)
        let SafariView : SFSafariViewController = SFSafariViewController(url: Url as! URL)
        self.present(SafariView, animated: true)
    }
    
    @objc func likePlace(_ sender: UIButton){
        print(sender.tag)
    }
    
    @objc func sharePlace(_ sender: UIButton){
        print(sender.tag)
        
        let place = self.places[sender.tag]
        let placeText = "이름 : \(place.placeName)\n주소 : \(place.addressName)\n전화번호 : \(place.phone)\nURL : \(place.placeURL)"
        var objectsToShare = [String]()
        
        objectsToShare.append(placeText)
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: - NAVER API
extension MapViewController{
    func updateCamera(_ place: Document){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(place.y)!, lng: Double(place.x)!))
        cameraUpdate.animation = .easeIn
        naverMapView.moveCamera(cameraUpdate)
        // 검색 결과 스크롤시 카메라 이동
    }
    
    func updateMarker(_ place: Document){
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: Double(place.y)!, lng: Double(place.x)!)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor(red: 245/255, green: 189/255, blue: 213/255, alpha: 1)
        markers.append(marker)
        marker.mapView = naverMapView
    }
    
    func deleteMarkers(){
        markers.forEach{
            $0.mapView = nil
        }
    }
    func mapOverlay(){
        let locationOverlay = naverMapView.locationOverlay
        locationOverlay.minZoom = 12
        locationOverlay.isMinZoomInclusive = true
        locationOverlay.maxZoom = 16
        locationOverlay.isMaxZoomInclusive = false
    }
}
