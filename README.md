# Apodini Collector

[![DOI](https://zenodo.org/badge/381725107.svg)](https://zenodo.org/badge/latestdoi/381725107)
[![codecov](https://codecov.io/gh/Apodini/ApodiniCollector/branch/develop/graph/badge.svg?token=HYmeGXzg9V)](https://codecov.io/gh/Apodini/ApodiniCollector)
[![jazzy](https://raw.githubusercontent.com/Apodini/ApodiniCollector/gh-pages/badge.svg)](https://apodini.github.io/ApodiniCollector/)
[![Build and Test](https://github.com/Apodini/ApodiniCollector/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/Apodini/ApodiniCollector/actions/workflows/build-and-test.yml)

`ApodiniCollector` combines [Collector](https://github.com/Apodini/Collector) with the [Apodini](https://github.com/Apodini/Apodini) framework used to create web services. it allows you to create trace spans, record metrics, and provide them to Prometheus instances.

## Traces

Apodini Collector provides integration in Apodini to configure and create trace spans in the web service. You can create a `TracerConfiguration` that defines global settings for the traces in the `WebService` configuration.
```swift
import Apodini
import ApodiniCollector
import ArgumentParser
import Foundation


@main
struct ExampleWebService: WebService {
    @Option var jaegerCollectorURL = URL(string: "http://localhost:14250")! // swiftlint:disable:this force_unwrapping
    
    
    var configuration: Apodini.Configuration {
        TracerConfiguration(
            serviceName: "example",
            jaegerURL: jaegerCollectorURL
        )
        
        // ...
    }

    
    var content: some Component {
        Group("metrics") {
            MetricsHandler()
        }
        // ...
    }
}
```

By using Apodini Collector, you can access the current tracer using the Apodini `@Environment`: `@Environment(\.tracer) var tracer: Tracer`

Apodini Collector exposes the tracing API defined in [Collector](https://github.com/Apodini/Collector) and allows you to propargate the spans in HTTPRequests of [AsyncHTTPClient](https://github.com/AsyncHttpClient/async-http-client/) or propargated in Apodini `Responses`:
```swift
var request = try HTTPClient.Request(url: "http://ase.in.tum.de/schmiedmayer")
let span = tracer.span(name: "Example")
span.propagate(in: &request)
```

In addition spans can be retrieved from [AsyncHTTPClient](https://github.com/AsyncHttpClient/async-http-client/) responses or the Apodini connection context:
```swift
import Apodini
import ApodiniCollector


struct ExampleHandler: Handler {
    @Environment(\.tracer) var tracer: Tracer
    @Environment(\.connection) var connection: Connection
    
    
    func handle() -> String {
        let span = tracer.span(name: "location", from: connection)
        // ...
    }
```



## Metrics

Apodini Collector exports the metrics creation API defined by the [Collector](https://github.com/Apodini/Collector) framework.

In addition to exporting the [Collector](https://github.com/Apodini/Collector) API surface Apodini Collector provides a `MetricsHandler` `Handler` enabling Prometheus instances to retrieve metrics information from the web service instance:
```swift
import Apodini
import ApodiniCollector


@main
struct ExampleWebService: WebService {
    var configuration: Apodini.Configuration {
        // ...
    }

    
    var content: some Component {
        Group("metrics") {
            MetricsHandler()
        }
        // ...
    }
}
```


## Contributing
Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/Apodini/.github/blob/main/CODE_OF_CONDUCT.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/ApodiniCollector/blob/develop/LICENSE) for more information.
