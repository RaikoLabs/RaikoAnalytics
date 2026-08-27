public protocol AnalyticsEvent: Sendable {
    var name: String { get }
    var parameters: [String: String] { get }
}
