//
//  AnalysisViewController.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/16.
//

import UIKit

class AnalysisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logoSet()
    }
}

extension AnalysisViewController{
    func logoSet(){
        self.navigationItem.title = "감정 분석"
    }
}
