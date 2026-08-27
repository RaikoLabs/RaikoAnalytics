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

// MARK: - Send Event:

public extension AnalyticsManager {
    func send(_ event: any AnalyticsEvent) {
        self.services.forEach { $0.send(event) }
    }
}
