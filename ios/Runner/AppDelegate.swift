import UIKit
import Flutter
import GoogleMaps




@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     // TODO: Add your API key
    // final const = DotEnv().env['MAPS_API_KEY'];
    //GMSServices.provideAPIKey("MAPS_API_KEY")

   //GMSServices.provideAPIKey("")
  

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
