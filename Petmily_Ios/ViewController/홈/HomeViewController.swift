//
//  HomeViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    let parameters = [
        "q":"Seoul",
        "appid": "d12719ff6add0324fbfe64e247fcd42f"
    ]
    
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherCountry: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherStatusImage: UIImageView!
    
    
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var PlaceButton: UIButton!
    @IBOutlet weak var AnalysisButton: UIButton!
    @IBOutlet weak var WeatherView: UIView!
    @IBOutlet weak var WeatherDetailView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoSet()
        layoutSet()
        searchWeather()
    }
}

//MARK: - layout set
extension HomeViewController{
    func logoSet(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "petmily.jpeg") //뒤에 배경 투명하게 바꾸기
        imageView.image = image
        
        self.navigationItem.titleView = imageView
    }
    
    func layoutSet(){
        LoginView.layer.cornerRadius = 30
        PlaceButton.layer.cornerRadius = 30
        PlaceButton.clipsToBounds = true
        AnalysisButton.layer.cornerRadius = 30
        AnalysisButton.clipsToBounds = true
        WeatherView.layer.cornerRadius = 30
        WeatherDetailView.layer.cornerRadius = 30
        
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
    }
}

//MARK: - button Event
extension HomeViewController{
    @IBAction func showPlace(_ sender: Any) {
        performSegue(withIdentifier: "showPlace", sender: self)
    }
    
    @IBAction func showAnalysis(_ sender: Any) {
        performSegue(withIdentifier: "showAnalysis", sender: self)
    }
}

//MARK: - OpenWeather APi
extension HomeViewController{
    func searchWeather(){
        AF.request(weatherUrl,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default
        )
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
                    self.homelayoutSet(json)
                    print(json) // 데이터 확인
                } catch(let error){
                    print("catch error : \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        })
    }
    
    func homelayoutSet(_ weather : WeatherResponse){
        let temperature = Double(weather.main.temp) - 273.15
        let weatherImgUrl = URL(string: "http://openweathermap.org/img/w/\(weather.weather[0].icon).png")
        print(weatherImgUrl)
        DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: weatherImgUrl!) {
                        if let image = UIImage(data: data) {
                            //UI 변경 작업은 main thread에서 해야함.
                            DispatchQueue.main.async {
                                self?.weatherStatusImage.image = image
                            }
                        }
                    }
                }
        
        weatherTemperature.text = String(format: "%.2f", temperature) + "℃"
        weatherStatus.text = weather.weather[0].main
        weatherCountry.text = "\(weather.sys.country), \(weather.name)  "
        windSpeed.text = "\(weather.wind.speed)m/s"
        cloudCover.text = "\(weather.clouds.all)%"
        humidity.text = "\(weather.main.humidity)%"
    }
}
