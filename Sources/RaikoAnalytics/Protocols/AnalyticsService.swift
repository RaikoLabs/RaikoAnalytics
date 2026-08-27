public protocol AnalyticsService: Sendable {
    func send(_ event: any AnalyticsEvent)
}
