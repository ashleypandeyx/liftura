import Cocoa
import FlutterMacOS
import FirebaseCore
import SwiftUI

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Initialize Firebase
    FirebaseApp.configure()

    // Additional setup after Firebase initialization, if needed.
    super.applicationDidFinishLaunching(notification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

struct YourApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

