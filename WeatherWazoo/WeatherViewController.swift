/*View controller implements your apps behavior. Controller manage the apps view and is the gateway between Model and Views.
 Controller cant talk to models directly it only interacts with viewModel and View.
 Views only talks to controller notifying of interaction event
 
 is a custom subclass of UIviewController so you have to override all the methods defined on UIViewController*/

import UIKit
import CoreSpotlight
import MobileCoreServices
import UserNotifications
import UserNotificationsUI

//MARK: - UIViewController Properties
@available(iOS 10.0, *)
class WeatherViewController: UIViewController {

  //MARK: - IBOutlets
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet var forecastViews: [ForecastView]!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
    //add description label
  let identifier = "WeatherIdentifier"
    
  let userDefaults = UserDefaults.standard

    
  
    //MARK: - Super Methods
    //start additional setup after overriding view controller
  override func viewDidLoad() {
    super.viewDidLoad()
    //edit
    UserDefaults.standard.register(defaults: [String : String]() )
    
    viewModel = WeatherViewModel()
    viewModel?.startLocationService()
  }
    
/*use viewWillAppear method to trigger operations that need to occur before the content view is presented onscreen*/
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    locationLabel.center.x  -= view.bounds.width
    iconLabel.center.x -= view.bounds.width
    temperatureLabel.center.x -= view.bounds.width
    
    iconLabel.alpha = 0.0
    locationLabel.alpha = 0.0
    temperatureLabel.alpha = 0.0
    
  }
/*user viewDidAppear to trigger any operation that need to occur as soon as the view is presented on screen in this case it fetches data and shows an animation*/
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.5, animations: {
     self.locationLabel.center.x += self.view.bounds.width
    })
    
    UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
     self.iconLabel.center.x += self.view.bounds.width
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
     self.temperatureLabel.center.x += self.view.bounds.width
    }, completion: nil)
    
    
    UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
     self.iconLabel.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
     self.locationLabel.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
     self.temperatureLabel.alpha = 1.0
    }, completion: nil)
    
  }
    

  // MARK: ViewModel
    /*didSet observes and is called after a viewModel is updated
     
     self refers to the view controller class*/
  var viewModel: WeatherViewModel? {
    didSet {
     viewModel?.location.observe {
        [unowned self] in
        self.locationLabel.text = $0    //sets location label with city name 
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = self.locationLabel.text
        
        let item = CSSearchableItem(uniqueIdentifier: self.identifier, domainIdentifier: "com.rushjet.SwiftWeather", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]){error in
            if let error =  error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Location item successfully indexed")
            }
        }
    }
    
     viewModel?.iconText.observe {
        [unowned self] in
        self.iconLabel.text = $0  //sets the icon
    }
    
     viewModel?.temperature.observe {
        [unowned self] in
        self.temperatureLabel.text = $0 //sets temp
    }
        
        viewModel?.message.observe {
            [unowned self] in
            self.messageLabel.text = $0
        }
        
        viewModel?.description.observe {
            [unowned self] in
            self.descriptionLabel.text = $0
        }
        
     viewModel?.forecasts.observe {  //sets forecast
        [unowned self] (forecastViewModels) in
        if forecastViewModels.count >= 4 {
            for (index, forecastView) in self.forecastViews.enumerated() {
                forecastView.loadViewModel(forecastViewModels[index])
            }
            }
 //edit noticiation

        let hour = self.userDefaults.integer(forKey: "hour_preference")
        let minute = self.userDefaults.integer(forKey: "minutes_preference")
        //print(hour)
        //print(minute)
        

        
        let notification = UNMutableNotificationContent()
        notification.title = "Good morning  ☕️ current \(self.descriptionLabel.text!) and \(self.temperatureLabel.text!)\u{00B0}"
        notification.body = self.messageLabel.text!
        notification.sound = UNNotificationSound.default()

        var dateInfo = DateComponents()
        dateInfo.hour = hour
        dateInfo.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
//create a timer for notification 5 seconds must be in background
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
/*create request object to send to ios asking for our notification to be registered and ready for use */
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: notification, trigger: trigger)
/*send our request to ios*/
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    
        
        }
      }
    }
  }
