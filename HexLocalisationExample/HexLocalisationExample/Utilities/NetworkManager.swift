//
//  NetworkManager.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 24/06/22.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published private(set) var isConnected: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    private init() {
        checkConnection()
    }
    
    private func checkConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
