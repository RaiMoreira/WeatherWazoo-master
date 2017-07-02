

import Foundation

struct Message {
  
    let messageText: String

    init(condition: Int){
   
    switch condition {
    case 200..<232: messageText = "shit its thunderstoming"
    case 300..<321: messageText = "its just drizzling"
    case 500..<531: messageText =  "its raining grab an umbrella "
    case 600..<622: messageText =  "get your snowboots ready"
    case 701..<781: messageText =  "atmosphere"
    case 800: messageText = "clear skiesss"
    case 801..<804: messageText =  "its just cloudy"
    case 900..<906: messageText =  "extreme weather"
    case 951..<962: messageText = "other weather"
    default: messageText = "default message"
                    }
    }
}
