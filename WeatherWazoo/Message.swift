/*These personalized notifications are based on the current weather ID code form the API website
 https://openweathermap.org/weather-conditions
 
 
 */

import Foundation

struct Message {
    
    let messageText: String
    
    init(condition: Int){
        
        switch condition {
        case 200..<233: messageText = "Be safe out there! ⛈" //all types of thunderstorms
        case 300..<322: messageText = "No worries its just a lil drizzle 🌧" //all types of drizzle
        case 500..<532: messageText =  "Don't forget your umbrella ☔️" //all types of rain
        case 600..<623: messageText =  "Get your snowboots ready" //all types of snow conditions
        case 701..<781: messageText =  "Be safe if you are driving 🌫" //mist,smoke,fog,haze...
        case 800: messageText = "Nothing beats a clear sky ☀️" //clear sky
        case 801..<805: messageText =  "Look on the bright side atleast its not raining ☁️" //clouds
        case 900..<903: messageText =  "Yo its crazy out there 🌪" //tornados,tropical storm, hurricane
        case 903: messageText = "Grab some gloves, a scarf, idk what to tell you but its COLD 💀"
        case 904: messageText = "Get yourself some shades maybe a frozen margarita cuz its HOT AS HELL 🔥"
        case 905: messageText = "Grab your sh*t before the wind blows it 💨"
        case 906: messageText = "Oh great now we got chunks of ice falling from the sky 🙄" //hail
        case 951..<958: messageText =  "Oh so breezzayyy 💨" //tornados,tropical storm, hurricane
        case 960..<963: messageText =  "Yo its crazyyy out there 🌪" //storm,violent storm, hurricane
        default: messageText = "Im not working right now be back later 😌"
        }
    }
}
