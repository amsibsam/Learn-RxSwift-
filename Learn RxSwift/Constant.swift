//
//  Constant.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 05/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation

class Constant {
    static var baseUrl: String {
        get {
            return "https://x.rajaapi.com/MeP7c5neQlOl2gPI1g9vmVX4jFAdkVq9dZCjhdtEBsXVSdwwPkdNsx3s0H/m"
        }
    }
    
    static var getKabupaten: String {
        get {
            return baseUrl + "/wilayah/kabupaten"
        }
    }
}
