//
//  TemplateMainService.swift
//  GitHubUsers
//
//  Created by APPLE on 10/8/22.
//

import Foundation
import ObjectMapper
import Alamofire

@objc protocol AppMainServiceDelegate : AnyObject {
    func didFetchData(responseData:Any) -> Void
    func didFailWithError(error:NSError) -> Void
}

class TemplateMainService: NSObject {

    weak var mainServerdelegate:AppMainServiceDelegate?
    override init() {
    }
    
    //--------------------------------------------------------------------------
    //------------ Get call through Alamofire ---------------------------------
    //--------------------------------------------------------------------------
    
    func getCallWithAlamofire(serverUrl: String) -> Void {
        
         print(serverUrl)
        let localHeaders: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
         let urlString = serverUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? serverUrl
         let mainThread = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        mainThread.async {
            
            AF.request(urlString, method: .get, parameters: nil ,encoding: URLEncoding.default, headers:localHeaders).responseJSON {  response in
                
                switch response.result {
                case let .success(value):
                    self.mainServerdelegate?.didFetchData(responseData: value)
                    print("JSON: \(value)") // serialized json response
                    return
                case let .failure(error):
                    print(error.localizedDescription)
                    self.mainServerdelegate?.didFailWithError(error: error as NSError)
                    return
                }
            }
        }
    }
}
