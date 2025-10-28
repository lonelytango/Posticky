import SwiftUI
import MarkdownUI
import HighlightSwift

// Build a MarkdownUI Theme and customize fonts/colors and code blocks.
// Use this with `.markdownTheme(HighlightedMarkdownTheme.theme)` or `.highlightedMarkdownTheme()`
enum HighlightedMarkdownTheme {
    // Base font size to keep relative calculations readable
    private static let baseFontSize: CGFloat = 14

    static let theme: Theme = Theme()
        .text {
            // Base text style
            FontSize(baseFontSize)
            ForegroundColor(.primary)
        }
        .code {
            // Inline code style (monospaced, slightly smaller than base)
            FontFamilyVariant(.monospaced)
            FontSize(.em(13.0 / baseFontSize))
            BackgroundColor(nil)
        }
        .codeBlock { configuration in
            // Render fenced code blocks.
            // NOTE: MarkdownUI's CodeBlockConfiguration exposes `configuration.language` and
            // `configuration.label` (a View), but not the raw code string. If your highlighter
            // requires a String, you'll need to provide the raw code text from your own model
            // or via a custom parsing step. Once you confirm the HighlightSwift API and how
            // you want to obtain the raw code text, you can replace `configuration.label`
            // with a custom view that uses the highlighter.
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTextStyle {
                    FontFamilyVariant(.monospaced)
                    FontSize(.em(13.0 / baseFontSize))
                    BackgroundColor(nil)
                }
                .padding(8)
                .background(Color(.textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
                .markdownMargin(top: 4, bottom: 8)
        }
}

// Placeholder for a future syntax-highlighting view.
// Replace this with the actual HighlightSwift view once you provide its API.
// Then, use it inside the codeBlock builder above, feeding it the code text and configuration.language.
private struct HighlightedCodeBlockView: View {
    let text: String
    let language: String?

    var body: some View {
        // TODO: Replace with the actual HighlightSwift view, e.g.:
        // SomeHighlightSwiftView(text: text, language: language)
        // For now, just show plain monospaced text.
        Text(text)
            .textSelection(.enabled)
            .font(.system(size: 13, weight: .regular, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Convenience to apply this theme at call sites.
extension View {
    func highlightedMarkdownTheme() -> some View {
        self.markdownTheme(HighlightedMarkdownTheme.theme)
    }
}
