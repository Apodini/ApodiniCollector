//
// This source file is part of the Apodini Collector open source project
//
// SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import Apodini
import JaegerCollector


private struct TracerStorageKey: StorageKey {
    typealias Value = Tracer
}


/// A `Configuration` to configure the Jaeger based `Tracer`
public struct TracerConfiguration: Apodini.Configuration {
    let serviceName: String
    let jaegerURL: URL
    
    
    /// - Parameters:
    ///   - serviceName: The service name used in the `Tracer` to identify this web service
    ///   - jaegerURL: The `URL` the Jaeger instance is located at
    public init(serviceName: String, jaegerURL: URL) {
        self.serviceName = serviceName
        self.jaegerURL = jaegerURL
    }
    
    
    public func configure(_ app: Application) {
        guard let host = jaegerURL.host, let port = jaegerURL.port else {
            fatalError("Could not identify a hostname and port in the URL: \(jaegerURL)")
        }
        
        let channel = ClientConnection.insecure(group: app.eventLoopGroup)
            .connect(host: host, port: port)
        
        let sender = JaegerSender(serviceName: serviceName, tags: [:], channel: channel)
        let agent = BasicAgent(interval: 60, sender: sender)
        
        app.storage[TracerStorageKey.self] = BasicTracer(agent: agent)
    }
}


extension Application {
    /// The `Tracer` that can be used in `Handler`s to retrieve and create new `Span`s
    public var tracer: Tracer {
        guard let tracer = self.storage[TracerStorageKey.self] else {
            fatalError("You need to add a TracerConfiguration to the WebService configuration to use the tracer in the Environment")
        }
        
        return tracer
    }
}
