//
//  Network.swift
//  
//
//  Created by Packiaseelan S on 20/06/22.
//

import Foundation

class Network {
    static let host: String = "3.133.155.49"
    static let port: Int = 50051
    
    static let note = NetworkBase(host: "", port: 0)
    
}

struct NetworkBase {
    let host: String
    let port: Int
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
}
