//
// This source file is part of the Apodini Collector open source project
//
// SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import AsyncHTTPClient
import Collector
import Foundation


private struct HTTPClientRequestModifier: Extractor, Injector {
    func extract(key: String, from carrier: HTTPClient.Request) -> String? {
        carrier.headers.first(name: key)
    }

    func inject(_ value: String, forKey key: String, into carrier: inout HTTPClient.Request) {
        carrier.headers.replaceOrAdd(name: key, value: value)
    }
}


extension Tracer {
    public func span(name: String, from request: HTTPClient.Request) -> Span {
        span(name: name, from: request, using: HTTPClientRequestModifier())
    }
}


extension Span {
    public func propagate(in request: inout HTTPClient.Request) {
        propagate(in: &request, using: HTTPClientRequestModifier())
    }
}
