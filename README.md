# RaikoAnalytics

A lightweight Swift package that fans a single analytics event out to any number of analytics providers behind one protocol-based API.

## Requirements

| Requirement | Version |
| --- | --- |
| Swift | 6.0 |
| iOS | 17.0 |
| macOS | 14.0 |

## Installation

### Swift Package Manager

Add the package in Xcode via **File → Add Package Dependencies…** and enter:

```
https://github.com/RaikoLabs/RaikoAnalytics.git
```

Or declare it in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RaikoLabs/RaikoAnalytics.git", from: "2.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "MyApp",
    dependencies: ["RaikoAnalytics"]
)
```

## Usage

### 1. Define an event

Conform your events to `AnalyticsEvent`:

```swift
import RaikoAnalytics

enum SignUpEvent: AnalyticsEvent {
    case completed(method: String)

    var name: String {
        switch self {
        case .completed: "sign_up_completed"
        }
    }

    var properties: [String: AnalyticsValue]? {
        switch self {
        case .completed(let method): ["method": .string(method), "is_first_launch": true]
        }
    }

    var userProperties: [String: AnalyticsValue]? { nil }
}
```

Screens and errors have their own protocols:

```swift
struct HomeScreenEvent: AnalyticsScreenEvent {
    let name = "home"
    let properties: [String: AnalyticsValue]? = nil
}

struct NetworkExceptionEvent: AnalyticsExceptionEvent {
    let error: any Error
    let properties: [String: AnalyticsValue]? = nil
}
```

Property values are typed as `AnalyticsValue`, so a type analytics providers don't accept fails at compile time. Literals convert automatically; wrap variables in a case, such as `.string(method)`. A service reads the underlying value with `value`, for SDKs that take `[String: Any]`.

### 2. Implement a service

Wrap each provider you use in an `AnalyticsService`. Because the protocol is `Sendable`, a service may be called from any isolation context:

```swift
import RaikoAnalytics

struct ConsoleAnalyticsService: AnalyticsService {
    func send(_ event: any AnalyticsEvent) {
        print("[Analytics] \(event.name) \(event.properties ?? [:])")
    }

    func sendScreen(_ event: any AnalyticsScreenEvent) {
        print("[Analytics] screen \(event.name)")
    }

    func sendException(_ event: any AnalyticsExceptionEvent) {
        print("[Analytics] exception \(event.error)")
    }
}
```

`sendScreen(_:)` and `sendException(_:)` have empty default implementations, so a service only implements the ones its provider supports.

### 3. Configure once

`AnalyticsManager` is a `@MainActor` singleton. Register your services during app start-up:

```swift
import RaikoAnalytics
import SwiftUI

@main
struct MyApp: App {
    init() {
        AnalyticsManager.shared.configure(services: [
            ConsoleAnalyticsService()
        ])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. Send events

Every configured service receives the event:

```swift
AnalyticsManager.shared.send(SignUpEvent.completed(method: "apple"))
AnalyticsManager.shared.sendScreen(HomeScreenEvent())
AnalyticsManager.shared.sendException(NetworkExceptionEvent(error: error))
```

## API

| Symbol | Description |
| --- | --- |
| `AnalyticsEvent` | Describes an event with a `name` and optional `properties` and `userProperties`. |
| `AnalyticsScreenEvent` | Describes a screen view with a `name` and optional `properties`. |
| `AnalyticsExceptionEvent` | Describes an `error` with optional `properties`. |
| `AnalyticsValue` | A property value: `.string`, `.int`, `.double` or `.bool`. |
| `AnalyticsService` | A provider that receives events via `send(_:)`, `sendScreen(_:)` and `sendException(_:)`. |
| `AnalyticsManager.shared` | The shared, main-actor isolated manager. |
| `configure(services:)` | Replaces the registered services. |
| `send(_:)` | Forwards an event to every registered service. |
| `sendScreen(_:)` | Forwards a screen event to every registered service. |
| `sendException(_:)` | Forwards an exception event to every registered service. |

## License

RaikoAnalytics is available under the MIT license. See [LICENSE](LICENSE) for details.
