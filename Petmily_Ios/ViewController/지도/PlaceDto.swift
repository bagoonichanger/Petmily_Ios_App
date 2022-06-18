//
//  PlaceDto.swift
//  Petmily_Ios
//
//  Created by 박우림 on 2022/06/18.
//

import Foundation

//MARK: - Response
public struct Response: Codable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document
public struct Document: Codable {
    let placeName, distance: String
    let placeURL: String
    let categoryName, addressName, roadAddressName, id: String
    let phone, categoryGroupCode, categoryGroupName, x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case distance
        case placeURL = "place_url"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case id, phone
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case x, y
    }
}

// MARK: - Meta
public struct Meta: Codable {
    let sameName: SameName
    let pageableCount, totalCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case sameName = "same_name"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}
// MARK: - SameName
public struct SameName: Codable {
    let region: [String]
    let keyword, selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case region, keyword
        case selectedRegion = "selected_region"
    }
}
