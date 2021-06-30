import Apodini
import JaegerCollector


fileprivate struct TracerStorageKey: StorageKey {
    typealias Value = Tracer
}


public struct TracerConfiguration: Apodini.Configuration {
    let serviceName: String
    let jaegerURL: URL
    
    
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
    public var tracer: Tracer {
        guard let tracer = self.storage[TracerStorageKey.self] else {
            fatalError("You need to add a TracerConfiguration to the WebService configuration to use the tracer in the Environment")
        }
        
        return tracer
    }
}
