/*Look at the forecast for warning
 list.weather (more info Weather condition codes)
 list.weather.id Weather condition id
 list.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
 list.weather.description Weather condition within the group
 list.weather.icon Weather icon id
 set flag for steep temperature drop
 */
import Foundation

func Helper(data: WeatherBuilder) -> String  {
    
    var msg = ""
    var message = ""
   // print(data)
    
    
    for index in 0...3{
        let one = Double(data.temperature!)
        let two = Double(data.forecasts![index].temperature)
        var difference: Double
        difference = one! - two!
        if difference > 20 {
            msg = "\nIt gets cooler! \(data.forecasts![index].temperature)\u{00B0} at \(data.forecasts![index].time) 🌬"
        }
        else if difference < -20 {
            msg = "\nIt gets warmer! \(data.forecasts![index].temperature)\u{00B0} at \(data.forecasts![index].time) 🔥"
            
        }
    }
//check for steep temperature drop or rise
    for index in 0...2{
        let one = Double(data.forecasts![index].temperature)
        let two = Double(data.forecasts![index+1].temperature)
        var difference: Double
        difference = one! - two!
        if difference > 15 {
            message = "\nSteep drop from  \(data.forecasts![index].temperature)\u{00B0} to \(data.forecasts![index+1].temperature)\u{00B0} between \(data.forecasts![index].time) and \(data.forecasts![index+1].time) 📉"
            
        }
        else if difference < -15 {
            message = "\nSteep increase from  \(data.forecasts![index].temperature)\u{00B0} to \(data.forecasts![index+1].temperature)\u{00B0} between \(data.forecasts![index].time) and \(data.forecasts![index+1].time) 📈"
            
        }
    }
    message = data.message! + msg + message
    
    //print(message)

    return message
}
