//
//  NetworkMonitor.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
                print("Network manager status changed: \(path.status)")
            }
        }
        monitor.start(queue: queue)
    }
}
