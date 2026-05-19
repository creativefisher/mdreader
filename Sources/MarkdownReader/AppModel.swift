import AppKit
import Foundation
import UniformTypeIdentifiers

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var currentFile: URL?
    @Published private(set) var markdown = ""
    @Published private(set) var errorMessage: String?
    @Published var isDropTargeted = false

    private let allowedExtensions = Set(["md", "markdown", "mdown", "mkd", "mkdn"])

    var title: String {
        currentFile?.lastPathComponent ?? "MarkdownReader"
    }

    var hasDocument: Bool {
        currentFile != nil && errorMessage == nil && !markdown.isEmpty
    }

    func openDocument() {
        let panel = NSOpenPanel()
        panel.title = "Open Markdown File"
        panel.prompt = "Open"
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = markdownContentTypes

        guard panel.runModal() == .OK, let url = panel.url else {
            return
        }

        load(url)
    }

    func reload() {
        guard let currentFile else {
            return
        }

        load(currentFile)
    }

    func load(_ url: URL) {
        guard isMarkdownFile(url) else {
            currentFile = url
            markdown = ""
            errorMessage = "This file is not a supported Markdown document."
            return
        }

        let accessed = url.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let data = try Data(contentsOf: url)
            guard let content = String(data: data, encoding: .utf8)
                ?? String(data: data, encoding: .unicode)
                ?? String(data: data, encoding: .isoLatin1)
            else {
                throw ReaderError.unsupportedEncoding
            }

            currentFile = url
            markdown = content
            errorMessage = nil
        } catch {
            currentFile = url
            markdown = ""
            errorMessage = "Could not read this file: \(error.localizedDescription)"
        }
    }

    func canLoad(_ url: URL) -> Bool {
        isMarkdownFile(url)
    }

    private var markdownContentTypes: [UTType] {
        let explicitTypes = allowedExtensions.compactMap { UTType(filenameExtension: $0) }
        return Array(Set(explicitTypes + [.plainText]))
    }

    private func isMarkdownFile(_ url: URL) -> Bool {
        allowedExtensions.contains(url.pathExtension.lowercased())
    }
}

private enum ReaderError: LocalizedError {
    case unsupportedEncoding

    var errorDescription: String? {
        "The file uses an unsupported text encoding."
    }
}
