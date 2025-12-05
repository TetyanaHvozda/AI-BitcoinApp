import SwiftUI
import Charts

struct PricePredictionChartView: View {
    let actual: [Double]
    let predicted: [Double]
    let dates: [Date]

    var body: some View {
        VStack(alignment: .leading) {
                    Text("Bitcoin Price vs Prediction")
                        .font(.title3.bold())
                        .padding(.horizontal)

            HStack(alignment: .top) {
                // Frozen Y-axis
                VStack {
                    Chart {
                        ForEach(0..<1, id: \.self) { i in
                            PointMark(
                                x: .value("Day", dates.first ?? Date()),
                                y: .value("Price", actual.first ?? 0)
                            )
                            .opacity(0) // Just to show axis
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis(.hidden)
                    .frame(width: 50, height: 300)
                }
                
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(actual.indices, id: \.self) { i in
                            PointMark(
                                x: .value("Day", dates[i]),
                                y: .value("Actual", actual[i])
                            )
                            .foregroundStyle(.blue)
                        }
                        
                        ForEach(predicted.indices, id: \.self) { i in
                            PointMark(
                                x: .value("Day", dates[i]),
                                y: .value("Predicted", predicted[i])
                            )
                            .foregroundStyle(.orange)
                        }
                    }
                    .frame(width: max(CGFloat(actual.count) * 60, 350), height: 300)
                    .padding()
                    .chartXAxis {
                        AxisMarks(values: dates) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date.formatted(.dateTime.month().day()))
                                    
                                }
                            }
                        }
                    }
                    .chartYAxis(.hidden)
                }
            }
                    HStack {
                        Label("Actual", systemImage: "circle.fill")
                            .foregroundColor(.blue)
                        Label("Predicted", systemImage: "circle.fill")
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)
                    .font(.caption)
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding()
            }
}

    #Preview {
    let count = 30
    let actual = (0..<count).map { _ in Double.random(in: 30000...35000) }
    let predicted = (0..<count).map { _ in Double.random(in: 30000...35000) }
    let startDate = Calendar.current.date(byAdding: .day, value: -count, to: Date())!
    let dates = (0..<count).map { offset in
        Calendar.current.date(byAdding: .day, value: offset, to: startDate)!
        }

    return PricePredictionChartView(
        actual: actual,
        predicted: predicted,
        dates: dates
    )
}
