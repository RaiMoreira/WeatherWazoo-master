/*ViewModel keeps track of app data and it only talks to Models(MVVM) */

import Foundation
import CoreLocation

class WeatherViewModel {
  // MARK: - Constants
  fileprivate let emptyString = ""

  // MARK: - Properties
  //create Observable variables
  let hasError: Observable<Bool>
  let errorMessage: Observable<String?>  //?there might not be an error

  let location: Observable<String>
  let iconText: Observable<String>
  let temperature: Observable<String>
  let forecasts: Observable<[ForecastViewModel]>

  let message: Observable<String>
  
  // MARK: - Services
  fileprivate var locationService: LocationService
  fileprivate var weatherService: WeatherServiceProtocol

  /*initializes all properties */
  // MARK: - init
  init() {
    hasError = Observable(false)
    errorMessage = Observable(nil)

    location = Observable(emptyString)
    iconText = Observable(emptyString)
    temperature = Observable(emptyString)
    forecasts = Observable([])
    
    message = Observable(emptyString)

    // Can put Dependency Injection here
    locationService = LocationService()
    weatherService = OpenWeatherMapService()
  }

  // MARK: - public
  func startLocationService() {
    locationService.delegate = self
    locationService.requestLocation()
  }

  // MARK: - private
  fileprivate func update(_ weather: Weather) {
      hasError.value = false
      errorMessage.value = nil

      location.value = weather.location    //updating all variables
      iconText.value = weather.iconText
      temperature.value = weather.temperature
    
      message.value = weather.message

      let tempForecasts = weather.forecasts.map { forecast in
        return ForecastViewModel(forecast)
      }
      forecasts.value = tempForecasts
  }
//in case cannot update display and error message and set all to variables to empty
  fileprivate func update(_ error: SWError) {
      hasError.value = true

      switch error.errorCode {
      case .urlError:
        errorMessage.value = "Sorry. The Open Weather Map Service is currently offline."
      case .networkRequestFailed:
        errorMessage.value = "Ops. The network request has failed"
      case .jsonSerializationFailed:
        errorMessage.value = "Sorry. We cannot process the weather information at this time."
      case .jsonParsingFailed:
        errorMessage.value = "Sorry. We cannot parse the weather information at this time."
      }

      location.value = emptyString
      iconText.value = emptyString
      temperature.value = emptyString
      self.forecasts.value = []
    
    message.value = emptyString
  }
}

// MARK: LocationServiceDelegate
extension WeatherViewModel: LocationServiceDelegate {
  func locationDidUpdate(_ service: LocationService, location: CLLocation) {
    weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
      DispatchQueue.main.async(execute: {
        if let unwrappedError = error {
          print(unwrappedError)
          self.update(unwrappedError)
          return
        }

        guard let unwrappedWeather = weather else {
          return
        }
        self.update(unwrappedWeather)
      })
    }
  }
}
