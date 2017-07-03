/*utility that uses the iPhone location services to find the current location of user*/

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
  func locationDidUpdate(_ service: LocationService, location: CLLocation)
}

class LocationService: NSObject {
  var delegate: LocationServiceDelegate?

  fileprivate let locationManager = CLLocationManager()

  override init() {
    super.init()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }

  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationService : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      print("The device's current coordinates are: \(location)")
      delegate?.locationDidUpdate(self, location: location)
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Sorry. There was an error using the location services: \(error.localizedDescription)")
  }
}
