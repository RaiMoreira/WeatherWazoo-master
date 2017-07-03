/*Remember in the MVVC architecture Models dont talk to anybody but the WeatherViewModel.swift file */

import Foundation

struct Weather {
  let location: String
  let iconText: String
  let temperature: String

  let forecasts: [Forecast]
    
  let message : String
}
