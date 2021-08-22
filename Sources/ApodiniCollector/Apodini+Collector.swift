//
// This source file is part of the Apodini Collector open source project
//
// SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import Apodini
import Collector
import ApodiniHTTP
import ApodiniVaporSupport


private struct ConnectionExtractor: Extractor {
    func extract(key: String, from carrier: Connection) -> String? {
        carrier.information[httpHeader: key]
    }
}

private struct ResponseInjector<C: Encodable>: Injector {
    func inject(_ value: String, forKey key: String, into carrier: inout Response<C>) {
        carrier.information = carrier.information.union([AnyHTTPInformation(key: key, rawValue: value)])
    }
}

extension Tracer {
    public func span(name: String, from connection: Connection) -> Span {
        span(name: name, from: connection, using: ConnectionExtractor())
    }
}

extension Span {
    public func propagate<C: Encodable>(in response: inout Response<C>) {
        propagate(in: &response, using: ResponseInjector<C>())
    }
}
