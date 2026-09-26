# RaikoAnalytics

A lightweight Swift package that fans a single analytics event out to any number of analytics providers behind one protocol-based API.

## Requirements

| Requirement | Version |
| --- | --- |
| Swift | 6.3 |
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
    .package(url: "https://github.com/RaikoLabs/RaikoAnalytics.git", from: "1.0.0")
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

    var parameters: [String: String] {
        switch self {
        case .completed(let method): ["method": method]
        }
    }
}
```

### 2. Implement a service

Wrap each provider you use in an `AnalyticsService`. Because the protocol is `Sendable`, a service may be called from any isolation context:

```swift
import RaikoAnalytics

struct ConsoleAnalyticsService: AnalyticsService {
    func send(_ event: any AnalyticsEvent) {
        print("[Analytics] \(event.name) \(event.parameters)")
    }
}
```

### 3. Configure once

`AnalyticsManager` is a `@MainActor` singleton. Register your services during app start-up:

```swift
import RaikoAnalytics
import SwiftUI

@main
struct MyApp: App {
    init() {
        MainActor.assumeIsolated {
            AnalyticsManager.shared.configure(services: [
                ConsoleAnalyticsService()
            ])
        }
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
```

### 5. Send events with implicit member syntax

Create a sender bound to your event type, then drop the type name at the call site:

```swift
let analytics = AnalyticsManager.shared.sender(for: SignUpEvent.self)

analytics.send(.completed(method: "apple"))
```

## API

| Symbol | Description |
| --- | --- |
| `AnalyticsEvent` | Describes an event with a `name` and string `parameters`. |
| `AnalyticsService` | A provider that receives events via `send(_:)`. |
| `AnalyticsManager.shared` | The shared, main-actor isolated manager. |
| `configure(services:)` | Replaces the registered services. |
| `send(_:)` | Forwards an event to every registered service. |
| `sender(for:)` | Returns an `AnalyticsSender` bound to one event type, enabling `send(.event)`. |

## License

RaikoAnalytics is available under the MIT license. See [LICENSE](LICENSE) for details.
