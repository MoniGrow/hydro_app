import WidgetKit
import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    do {
        let user = Auth.auth().currentUser
        user?.getIDToken(completion: <#T##((String?, Error?) -> Void)?##((String?, Error?) -> Void)?##(String?, Error?) -> Void#>)
        print("LLLLLLLLLLLLLLLLLLLLLLLLLL")
        print(user)

        let uid: String
        if user != nil {
            uid = user!.uid
        } else {
            uid = ""
        }
        let data = try JSONEncoder().encode(uid)
         let container = UserDefaults(suiteName:"group.com.monigrow.widgetContainer")
             container?.setValue(data, forKey: "uid")
                           
         /// Used to let the widget extension to reload the timeline
         WidgetCenter.shared.reloadAllTimelines()

         } catch {
           print("Unable to encode WidgetDay: \(error.localizedDescription)")
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
