
import Foundation

struct ForecastViewModel {
  let time: Observable<String>
  let iconText: Observable<String>
  let temperature: Observable<String>
    
  let description: Observable<String>
  let id: Observable<String>
  init(_ forecast: Forecast) {
    time = Observable(forecast.time)
    iconText = Observable(forecast.iconText)
    temperature = Observable(forecast.temperature)
    description = Observable(forecast.description) //light rain 
    id = Observable(forecast.id)
    
  }
}
