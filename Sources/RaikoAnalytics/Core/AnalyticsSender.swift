// The MIT License (MIT)
//
// Copyright (c) 2026 Raiko Labs, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// Sends events of a single, concrete `AnalyticsEvent` type through an `AnalyticsManager`.
///
/// Because the event type is known, events can be written with implicit member syntax:
///
/// ```swift
/// let analyticsManager = AnalyticsManager.shared.sender(for: AnalyticsName.self)
/// analyticsManager.send(.homeSeen)
/// ```
@MainActor
public struct AnalyticsSender<Event: AnalyticsEvent>: Sendable {

    // MARK: - Parameter:

    private let manager: AnalyticsManager

    // MARK: - Initialization:

    init(manager: AnalyticsManager) {
        self.manager = manager
    }
}

// MARK: - Send Event:

public extension AnalyticsSender {
    func send(_ event: Event) {
        self.manager.send(event)
    }
}

// MARK: - Sender:

public extension AnalyticsManager {
    func sender<Event: AnalyticsEvent>(for eventType: Event.Type) -> AnalyticsSender<Event> {
        AnalyticsSender(manager: self)
    }
}
