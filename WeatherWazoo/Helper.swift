/*Look at the forecast for warning
 list.weather (more info Weather condition codes)
 list.weather.id Weather condition id
 list.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
 list.weather.description Weather condition within the group
 list.weather.icon Weather icon id
 
 
 


import UIKit

class Helper: UIViewController {

    func warn(person: String, alreadyGreeted: Bool) -> String {
        if alreadyGreeted {
            return greetAgain(person: person)
        } else {
            return greet(person: person)
        }
    }
}
 */
