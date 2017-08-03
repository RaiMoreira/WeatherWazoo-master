
import Foundation

struct WeatherBuilder {
  var location: String?
  var iconText: String?
  var temperature: String?

  var forecasts: [Forecast]?

  var message: String?
  var description: String?

  func build() -> Weather {             //function accepts type parameters and returns object Weather 
    return Weather(location: location!,
                      iconText: iconText!,
                   temperature: temperature!,
                   forecasts: forecasts!,
                   message: message!,
                   description: description!)
  }
}
