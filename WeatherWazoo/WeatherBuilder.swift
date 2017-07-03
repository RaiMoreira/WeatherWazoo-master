
import Foundation

struct WeatherBuilder {
  var location: String?
  var iconText: String?
  var temperature: String?

  var forecasts: [Forecast]?

  var message: String?

  func build() -> Weather {
    return Weather(location: location!,
                      iconText: iconText!,
                   temperature: temperature!,
                   forecasts: forecasts!,
                   message: message!)
  }
}
