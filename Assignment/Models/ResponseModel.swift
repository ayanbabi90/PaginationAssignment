//
//  ResponseModel.swift
//  Assignment
//
//  Created by Ayan Chakraborty on 07/09/20.
//  Copyright © 2020 Assignment Ayan Chakraborty. All rights reserved.
//

import Foundation

struct RequestHeader: Codable {
    var authToken, userId, apiName, appVersion: String?
    
    enum CodingKeys: String, CodingKey {
           case authToken = "AuthToken", userId = "UserId", apiName = "Api-Name", appVersion = "App-Version"
    }
}

struct RequestBody: Codable {
    var branchId: Int = 0
    var page: Int = 0
    
     enum CodingKeys: String, CodingKey {
        case branchId,page
    }
}

// MARK: - ResponseModel
struct ResponseModel: Codable {
    var statusCode: Int?
    var status: Bool?
    var message: String?
    var response: ResponseBody?
}

// MARK: - Response
struct ResponseBody: Codable {
    var numberOfPages, currentPage: Int?
    var slots: [String]?
    var items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    var itemID, itemName: String?
    var price: Int?
    var currency: String?
    var offerPrice: Double?
    var category: String?
    var foodType: String?
    var image: String?
    var slots: [String]?

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemName, price, currency, offerPrice, category, foodType, image, slots
    }
}
