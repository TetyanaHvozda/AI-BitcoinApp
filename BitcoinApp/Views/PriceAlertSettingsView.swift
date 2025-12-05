import SwiftUI
import UserNotifications

struct PriceAlertSettingsView: View {
    @ObservedObject var alertManager = PriceAlertManager.shared
    var body: some View {
        Form {
            Section(header: Text("Set Price Alert")) {
                Toggle("Enable Alerts", isOn: $alertManager.notificationsEnabled)
                Picker("Notify when price is", selection: $alertManager.condition) {
                    ForEach(PriceAlertManager.PriceCondition.allCases) { condition in
                        Text(condition.rawValue.capitalized).tag(condition)
                    }
                }
                TextField("Enter target price", value: $alertManager.targetPrice, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            
            Button("Save Settings") {
                alertManager.saveSettings()
                // Immediately fetch the current price and check for alert
                BitcoinPriceService.fetchRealTimePrice { price in
                    if let price = price {
                        print("ℹ️ Fetched price: \(price)")
                        PriceAlertManager.shared.checkAndNotify(currentPrice: price)
                    } else {
                        print("❌ Failed to fetch price when saving alert")
                    }
                }
            }
            
        }
        .navigationTitle("Price Alert")
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                if granted {
                    print("✅ Notification permission granted")
                } else {
                    print("⚠️ Notification permission denied")
                }
            }
        }
    }
            }
    
    #Preview {
        PriceAlertSettingsView()
    }

