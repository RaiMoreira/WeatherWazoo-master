//
//  Notification.swift
//  WeatherWazoo
//
//  Created by Ray Moreira on 8/2/17.
//  Copyright © 2017 Ray Moreira. All rights reserved.
//

import UIKit
import UIKit
import CoreSpotlight
import MobileCoreServices
import UserNotifications
import UserNotificationsUI

@available(iOS 10.0, *)
class Notification: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func scheduleLocal(taskTypeId: String) {
     let notification = UNMutableNotificationContent()
     notification.title = "Danger Will Robinson"
     notification.subtitle = "Something This Way Comes"
     notification.body = "I need to tell you something, but first read this."
     notification.sound = UNNotificationSound.default()
     /*create a timer for notification 5 seconds must be in background*/
     let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
     
     /*create request object to send to ios asking for our notification to be registered and ready for use */
     let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
     /*send our request to ios*/
     UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
     }

}
