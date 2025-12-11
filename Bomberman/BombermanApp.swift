import SwiftUI

@main
struct BombermanApp: App {
    @StateObject private var gameClient = GameClient.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(gameClient)
        }
    }
}
