import Apodini
import PrometheusCollector


public struct MetricsHandler: Handler {
    @Environment(\.eventLoopGroup) var eventLoopGroup: EventLoopGroup
    
    
    public init() {
        Metric.setup()
    }
    
    
    public func handle() -> EventLoopFuture<Blob> {
        Metric.buffer(on: eventLoopGroup.next()).map { buffer in
            Blob(buffer, type: .text(.plain))
        }
    }
}
