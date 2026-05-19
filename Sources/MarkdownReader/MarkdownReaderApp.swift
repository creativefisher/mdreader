import SwiftUI

@main
struct MarkdownReaderApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .frame(minWidth: 760, minHeight: 560)
        }
        .windowStyle(.titleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open...") {
                    appModel.openDocument()
                }
                .keyboardShortcut("o", modifiers: .command)
            }

            CommandMenu("Document") {
                Button("Reload") {
                    appModel.reload()
                }
                .keyboardShortcut("r", modifiers: .command)
                .disabled(appModel.currentFile == nil)
            }
        }
    }
}
