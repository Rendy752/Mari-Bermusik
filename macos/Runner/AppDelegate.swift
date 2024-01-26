import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
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
    return true
  }
}
