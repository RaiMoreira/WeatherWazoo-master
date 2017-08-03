
import Foundation

struct ForecastDateTime {
  let rawDate: Double

  init(_ date: Double) {
    rawDate = date
  }

  var shortTime: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let date = Date(timeIntervalSince1970: rawDate)
    return dateFormatter.string(from: date)
  }
}
