//
//  SearchResultModel.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import Foundation
import ObjectMapper

class SearchResultMainModel: Mappable{
    
    var total_count: Int?
    var incomplete_results: Bool?
    var items = [ItemsListModel]()
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        total_count <- map["total_count"]
        incomplete_results <- map["incomplete_results"]
        items <- map["items"]
    }
}

class ItemsListModel: Mappable{
    
    var name: String?
    var id: Int?
    var node_id: String?
    var avatar_url: String?
    var url: String?
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var type: String?
    var repos_url: String?
    var score: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["login"]
        id <- map["id"]
        node_id <- map["node_id"]
        avatar_url <- map["avatar_url"]
        url <- map["url"]
        followers_url <- map["followers_url"]
        following_url <- map["following_url"]
        gists_url <- map["gists_url"]
        type <- map["type"]
        repos_url <- map["repos_url"]
        score <- map["score"]
    }
}

