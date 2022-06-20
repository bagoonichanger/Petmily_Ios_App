//
//  MapCollectionViewCell.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/19.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeNumber: UILabel!
    @IBOutlet weak var placeCategory: UILabel!
    @IBOutlet weak var stbackView: UIView!
    
    
    func updateUI(place: Document){
        placeName.text = place.placeName
        placeAddress.text = place.addressName
        if(place.phone == ""){
            placeNumber.text = "전화번호가 없습니다."
        } else {
            placeNumber.text = place.phone
        }
            
        placeCategory.text = place.categoryName
    }
}
