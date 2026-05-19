# MarkdownReader

A native macOS Markdown reader built with SwiftUI.

## Rendering checklist

- [x] Headings and paragraphs
- [x] Lists and task lists
- [x] Tables
- [x] Code blocks
- [x] Blockquotes

| Feature | Status |
| --- | --- |
| Native SwiftUI window | Ready |
| GitHub Flavored Markdown | Ready |
| Read-only file viewing | Ready |

```swift
import SwiftUI

struct Example: View {
    var body: some View {
        Text("Markdown looks good here.")
    }
}
```

> Drop another Markdown file onto the window or use File > Open.
