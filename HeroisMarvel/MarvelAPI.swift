//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Bruno Vieira Souza on 12/03/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "2914682779c1b6f89fe1d2536b6a91e82ed123e2"
    static private let publicKey = "1f9a5811e6f27eea000f90704677c473"
    static private let limit = 50
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5("\(ts)\(privateKey)\(publicKey)").lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startWith: String
        if let name = name, !name.isEmpty {
            startWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startWith + getCredentials()
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                onComplete(nil)
                return
                
            }
            do {
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
}
