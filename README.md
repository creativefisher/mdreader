# MarkdownReader

MarkdownReader is a small native macOS app for opening and reading local Markdown files with SwiftUI typography and GitHub Flavored Markdown rendering.

## Features

- Open Markdown files from the File menu or toolbar.
- Drag and drop Markdown files onto the window.
- Reload the current document with `Command-R`.
- Read tables, task lists, code blocks, blockquotes, links, and images.
- Select and copy rendered text.
- Works in light and dark mode.

## Requirements

- macOS 14 or newer
- Xcode Command Line Tools or Xcode with Swift 6

Install the command line tools if needed:

```bash
xcode-select --install
```

## Run From Source

```bash
git clone <repo-url>
cd MarkdownReader
make run
```

## Install Locally

Build and install the app into your user Applications folder:

```bash
make install
```

Then launch it from Finder, Spotlight, or:

```bash
open ~/Applications/MarkdownReader.app
```

If macOS warns that the app is from an unidentified developer, right-click `MarkdownReader.app`, choose **Open**, then confirm.

## Build Commands

```bash
make build      # Compile the debug executable
make run        # Launch from SwiftPM
make package    # Create .build/release/MarkdownReader.app
make install    # Copy the app to ~/Applications
make uninstall  # Remove the app from ~/Applications
make clean      # Remove SwiftPM build artifacts
```

## Manual Smoke Test

After installing, open `Samples/example.md` and check:

- File > Open
- Toolbar Open
- Reload
- Drag and drop
- Light and dark mode
- Tables
- Task lists
- Code blocks
- Blockquotes
- Links
- Invalid files

## Project Layout

```text
Package.swift
Resources/Info.plist
Samples/example.md
Scripts/package-app.sh
Sources/MarkdownReader/
```

## Notes

The packaged app is unsigned. Do not commit `.build/` or generated `.app` bundles.
