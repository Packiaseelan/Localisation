//
//  TestService.swift
//  
//
//  Created by Packiaseelan S on 20/06/22.
//

import Foundation
import GRPC

import GRPC
import NIOCore
import NIOPosix

class TestService {
    static let shared = TestService()
    private var client: Trainer_GreeterAsyncClient?
    
    private init() {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let connection = ConnectionTarget.host(Network.host, port: Network.port)
        
        do {
            let channel = try GRPCChannelPool.with(
                target: connection,
                transportSecurity: .plaintext,
                eventLoopGroup: group
            )
            client = Trainer_GreeterAsyncClient(channel: channel)
            
        } catch let error {
            print("Error init service client: \(error)")
        }
    }
    
    func sayHello(name: String? = nil) async {
        if let client = client {
            let request = Trainer_HelloRequest.with {
                $0.name = name ?? "my name"
            }
            do {
                let greeting = try await client.sayHello(request)
                print("Greeter received: \(greeting.message)")
            } catch {
                print("Greeter failed: \(error)")
            }
        }
    }
}
