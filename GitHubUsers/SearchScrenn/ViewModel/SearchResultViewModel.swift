//
//  SearchResultViewModel.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import Foundation
import ObjectMapper

@objc protocol SearchResultProtocol
{
    @objc optional
    func didFetchUsersResultData(responseData: Any) -> Void
    @objc optional
    func didFailUsersResultDataWithError(error: NSError) -> Void
}

class SearchResultViewModel: TemplateMainService, AppMainServiceDelegate {
    
    weak var searchResultDelegate: SearchResultProtocol?
    var message = ""
    var serverUrl: String?
    
    static let sharedInstance :SearchResultViewModel =
    {
        let instance = SearchResultViewModel()
        return instance
    }()
    
    func didFetchData(responseData: Any) {
        self.searchResultDelegate?.didFetchUsersResultData?(responseData: responseData)
    }
    
    func didFailWithError(error: NSError) {
        self.searchResultDelegate?.didFailUsersResultDataWithError?(error: error)
    }
    
    // ----------------------------------------------------------------------
    // ----------------- Server call for Search result ------------------
    //------------------------------------------------------------------------
    func getSearchUsersResult(delegate:SearchResultProtocol, query: String, page: Int) -> Void {
        self.searchResultDelegate = delegate
        super.mainServerdelegate = self
        let baseUrl = "https://api.github.com/search/users?"
        let url = "\(baseUrl)q=\(query)&page=\(page)"
        super.getCallWithAlamofire(serverUrl: url)
    }
    
    // ----------------------------------------------------------------------
    // ----------------- Parse Search Result Data ------------------
    //------------------------------------------------------------------------
    func didParseSearchReasultData(completion: @escaping ((SearchResultMainModel?, Bool, String) -> Void) , responseData:Any) {
        if let jsonModel =  Mapper<SearchResultMainModel>().map(JSONObject: responseData ) {
            if jsonModel.items.count != 0 {
                self.message = "Success"
                completion(jsonModel, true, self.message)
            } else {
                self.message = "Failure"
                completion(nil, false, self.message)
            }
        }
    }
}
