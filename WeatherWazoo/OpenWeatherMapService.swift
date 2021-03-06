

import Foundation
import CoreLocation

import SwiftyJSON

struct OpenWeatherMapService: WeatherServiceProtocol {
  fileprivate let urlPath = "http://api.openweathermap.org/data/2.5/forecast"

  fileprivate func getFirstFourForecasts(_ json: JSON) -> [Forecast] {
    var forecasts: [Forecast] = []

    for index in 0...3 {
      guard let forecastTempDegrees = json["list"][index]["main"]["temp"].double,
        let rawDateTime = json["list"][index]["dt"].double,
        let forecastCondition = json["list"][index]["weather"][0]["id"].int,
        let forecastDescription = json["list"][0]["weather"][0]["description"].string,
        let forecastIcon = json["list"][index]["weather"][0]["icon"].string else {
          break
      }

      let country = json["city"]["country"].string
      let forecastTemperature = Temperature(country: country!,
        openWeatherMapDegrees: forecastTempDegrees)
      let forecastTimeString = ForecastDateTime(rawDateTime).shortTime
      let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: forecastIcon)
      let forcastIconText = weatherIcon.iconText
      let forecastDesc = forecastDescription
      let forecastId = String(forecastCondition)
        
      let forecast = Forecast(time: forecastTimeString,
                          iconText: forcastIconText,
                       temperature: forecastTemperature.degrees,
                       description: forecastDesc,
                       id: forecastId)

      forecasts.append(forecast)
    }
    return forecasts
  }
/*this function retrieves the weather information live */
    

  func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)

    guard let url = generateRequestURL(location) else {
      let error = SWError(errorCode: .urlError)
      completionHandler(nil, error)
      return
    }

    print(url)
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request,
        completionHandler: { data, response, networkError in

      // Check network error
      guard networkError == nil else {
        let error = SWError(errorCode: .networkRequestFailed)
        completionHandler(nil, error)
        return
      }

      // Check JSON serialization error
      guard let unwrappedData = data else {
        let error = SWError(errorCode: .jsonSerializationFailed)
        completionHandler(nil, error)
        return
      }

      let json = JSON(data: unwrappedData)

      // Get temperature, location and icon and check parsing error
      guard let tempDegrees = json["list"][0]["main"]["temp"].double,
        let country = json["city"]["country"].string,
        let city = json["city"]["name"].string,
        //let message = json["list"][0]["weather"][0]["description"].string,
        let weatherCondition = json["list"][0]["weather"][0]["id"].int,
        let description = json["list"][0]["weather"][0]["description"].string,
        let iconString = json["list"][0]["weather"][0]["icon"].string else {
          let error = SWError(errorCode: .jsonParsingFailed)
          completionHandler(nil, error)
          return
      }

      var weatherBuilder = WeatherBuilder()
      let temperature = Temperature(country: country, openWeatherMapDegrees:tempDegrees)
      weatherBuilder.temperature = temperature.degrees
      weatherBuilder.location = city
      weatherBuilder.description = description  //description light raint
      let weatherIcon = WeatherIcon(condition: weatherCondition, iconString: iconString)
      weatherBuilder.iconText = weatherIcon.iconText

            //edit
     //print(weatherBuilder)
     let customMessage = Message(condition: weatherCondition)  //sends id to return custom message
     weatherBuilder.message = customMessage.messageText  //custom message
            
            

      weatherBuilder.forecasts = self.getFirstFourForecasts(json)
      weatherBuilder.message = Helper(data: weatherBuilder)

      completionHandler(weatherBuilder.build(), nil)
    })

    task.resume()
  }

  fileprivate func generateRequestURL(_ location: CLLocation) -> URL? {
    guard var components = URLComponents(string:urlPath) else {
      return nil
    }

    
    // get appId from Info.plist file
    let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
    let parameters = NSDictionary(contentsOfFile:filePath)
    let appId = parameters!["OWMAccessToken"]! as! String

    let latitude = String(location.coordinate.latitude)
    let longitude = String(location.coordinate.longitude)

    components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                             URLQueryItem(name:"lon", value:longitude),
                             URLQueryItem(name:"appid", value:appId)]

    return components.url
  }
}
