//
//  WalkViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit

class WalkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        logoSet()
    }
}

extension WalkViewController{
    func logoSet(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "petmily.jpeg") //뒤에 배경 투명하게 바꾸기
        imageView.image = image
        
        self.navigationItem.titleView = imageView
    }
}
