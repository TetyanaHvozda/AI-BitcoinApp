import Foundation
import UserNotifications

class PriceAlertManager: ObservableObject {
    static let shared = PriceAlertManager()

    @Published var targetPrice: Double = UserDefaults.standard.double(forKey: "targetPrice")
    @Published var condition: PriceCondition = PriceCondition(rawValue: UserDefaults.standard.string(forKey: "priceCondition") ?? "below") ?? .below
    @Published var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "alertsEnabled")

    enum PriceCondition: String, CaseIterable, Identifiable {
        case above
        case below

        var id: String { self.rawValue }
    }

    func saveSettings() {
        UserDefaults.standard.set(targetPrice, forKey: "targetPrice")
        UserDefaults.standard.set(condition.rawValue, forKey: "priceCondition")
        UserDefaults.standard.set(notificationsEnabled, forKey: "alertsEnabled")
    }

    func checkAndNotify(currentPrice: Double) {
        guard notificationsEnabled else { return }

        let shouldNotify = (condition == .below && currentPrice < targetPrice)
                        || (condition == .above && currentPrice > targetPrice)

        if shouldNotify {
            triggerNotification(currentPrice: currentPrice)
            notificationsEnabled = false  // disable after first alert
            saveSettings()
        }
    }

    private func triggerNotification(currentPrice: Double) {
        let content = UNMutableNotificationContent()
        content.title = "💰 Bitcoin Price Alert"
        content.body = "BTC is now \(condition == .below ? "below" : "above") $\(Int(targetPrice)). Current price: $\(Int(currentPrice))"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule alert: \(error.localizedDescription)")
            } else {
                print("✅ Price alert notification scheduled")
            }
        }
    }
}

