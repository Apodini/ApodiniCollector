//
// This source file is part of the Apodini Collector open source project
//
// SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

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
