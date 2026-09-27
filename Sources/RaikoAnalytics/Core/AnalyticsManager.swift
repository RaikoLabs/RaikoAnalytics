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

@MainActor
public final class AnalyticsManager {

    // MARK: - Shared:

    public static let shared = AnalyticsManager()

    // MARK: - Parameter:

    private var services: [any AnalyticsService] = []

    // MARK: - Initialization:

    private init() { }
}

// MARK: - Configure:

public extension AnalyticsManager {
    func configure(services: [any AnalyticsService]) {
        self.services = services
    }
}

// MARK: - Send:

public extension AnalyticsManager {
    func send(_ event: any AnalyticsEvent) {
        self.services.forEach { $0.send(event) }
    }
    
    func sendScreen(_ event: any AnalyticsScreenEvent) {
        self.services.forEach { $0.sendScreen(event) }
    }
    
    func sendException(_ event: any AnalyticsExceptionEvent) {
        self.services.forEach { $0.sendException(event) }
    }
}
