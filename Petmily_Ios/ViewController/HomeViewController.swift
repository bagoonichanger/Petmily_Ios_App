//
//  HomeViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    }
}

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

extension HomeViewController{
    @IBAction func showPlace(_ sender: Any) {
        performSegue(withIdentifier: "showPlace", sender: self)
    }
    
    @IBAction func showAnalysis(_ sender: Any) {
        performSegue(withIdentifier: "showAnalysis", sender: self)
    }
}
