@preconcurrency import MarkdownUI
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            ReaderBackground()

            Group {
                if let errorMessage = appModel.errorMessage {
                    MessageView(
                        title: "Unable to Open Document",
                        message: errorMessage,
                        actionTitle: "Choose Another File",
                        action: appModel.openDocument
                    )
                } else if appModel.hasDocument {
                    MarkdownDocumentView(markdown: appModel.markdown)
                } else {
                    MessageView(
                        title: "Open a Markdown File",
                        message: "Choose a local Markdown document to view it with native macOS typography, tables, task lists, images, and code blocks.",
                        actionTitle: "Open File",
                        action: appModel.openDocument
                    )
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
        .navigationTitle(appModel.title)
        .toolbar {
            ToolbarItemGroup {
                Button(action: appModel.openDocument) {
                    Label("Open", systemImage: "folder")
                }

                Button(action: appModel.reload) {
                    Label("Reload", systemImage: "arrow.clockwise")
                }
                .disabled(appModel.currentFile == nil)
            }
        }
        .dropDestination(for: URL.self) { urls, _ in
            guard let url = urls.first, appModel.canLoad(url) else {
                return false
            }

            appModel.load(url)
            return true
        } isTargeted: { isTargeted in
            appModel.isDropTargeted = isTargeted
        }
        .overlay {
            if appModel.isDropTargeted {
                DropOverlay()
            }
        }
    }
}

private struct MarkdownDocumentView: View {
    let markdown: String

    var body: some View {
        ScrollView {
            Markdown(markdown)
                .markdownTheme(.reader)
                .textSelection(.enabled)
                .frame(maxWidth: 860, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 22)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

private struct MessageView: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 46, weight: .regular))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.weight(.semibold))

                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .frame(maxWidth: 460)
            }

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ReaderBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color(nsColor: .windowBackgroundColor) : Color(nsColor: .textBackgroundColor))
            .ignoresSafeArea()
    }
}

private struct DropOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(.tint, style: StrokeStyle(lineWidth: 3, dash: [9, 7]))
            .background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            .padding(18)
            .allowsHitTesting(false)
    }
}

private extension Theme {
    @MainActor
    static var reader: Theme {
        Theme.gitHub
            .text {
                FontFamily(.system(.default))
                FontSize(17)
                ForegroundColor(.primary)
            }
            .paragraph { configuration in
                configuration.label
                    .relativeLineSpacing(.em(0.26))
                    .markdownMargin(top: 0, bottom: 16)
            }
            .heading1 { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(34)
                        FontWeight(.semibold)
                    }
                    .markdownMargin(top: 20, bottom: 16)
            }
            .heading2 { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(27)
                        FontWeight(.semibold)
                    }
                    .markdownMargin(top: 26, bottom: 12)
            }
            .heading3 { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(22)
                        FontWeight(.semibold)
                    }
                    .markdownMargin(top: 20, bottom: 10)
            }
            .blockquote { configuration in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor.opacity(0.55))
                        .frame(width: 4)

                    configuration.label
                        .foregroundStyle(.secondary)
                }
                .markdownMargin(top: 4, bottom: 16)
            }
            .codeBlock { configuration in
                ScrollView(.horizontal) {
                    configuration.label
                        .relativeLineSpacing(.em(0.18))
                        .markdownTextStyle {
                            FontFamilyVariant(.monospaced)
                            FontSize(14)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(nsColor: .controlBackgroundColor), in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(nsColor: .separatorColor).opacity(0.7))
                }
                .markdownMargin(top: 4, bottom: 18)
            }
    }
}
