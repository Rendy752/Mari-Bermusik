import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Load .env file
    if let path = Bundle.main.path(forResource: ".env", ofType: nil) {
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            let apiKey = myStrings[0].components(separatedBy: "=")[1]
            
            // Set API key in Info.plist
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), 
               var dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                dict["API_KEY"] = apiKey as AnyObject
                let newDict = NSDictionary(dictionary: dict)
                newDict.write(toFile: path, atomically: true)
            }
        } catch {
            print(error)
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
