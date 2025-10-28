//
//  NoteView.swift
//  MarkdownStickies
//
//  Created by Zian Chen on 10/27/25.
//

import HighlightSwift
import MarkdownUI
import SwiftUI

// Helper struct to encapsulate the Note editing logic (the detail view)
struct NoteDetailView: View {
    
    @Bindable var note: Note
    
    private let placeholderText: String = "Start typing your notes here..."
    
    // Proportional width of the editor (0.25...0.75)
    @State private var editorProportion: CGFloat = 0.5
    @State private var isDraggingDivider: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Title field at the top spanning both panes
            TextField("Note Title", text: $note.title)
                .font(.title)
                .textFieldStyle(.plain)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.clear)
            
            Divider()
            
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let editorWidth = max(200, min(totalWidth - 200, totalWidth * editorProportion))
                
                HStack(spacing: 6) {
                    // Editor
                    ZStack(alignment: .topLeading) {
                        if note.content.isEmpty {
                            Text(placeholderText)
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.top, 10)
                                .padding(.horizontal, 6)
                        }
                        TextEditor(text: $note.content)
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .opacity(note.content.isEmpty ? 0.25 : 1)
                            .padding(6)
                    }
                    .frame(width: editorWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color(.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    // Draggable divider
                    Divider()
                        .frame(width: 6)
                        .background(isDraggingDivider ? Color.accentColor.opacity(0.3) : Color.clear)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    isDraggingDivider = true
                                    let newProportion = (editorWidth + value.translation.width) / totalWidth
                                    editorProportion = min(max(newProportion, 0.25), 0.75)
                                }
                                .onEnded { _ in
                                    isDraggingDivider = false
                                }
                        )
                        .onHover { hovering in
                            if hovering {
                                NSCursor.resizeLeftRight.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    
                    // Preview
                    ScrollView {
                        Markdown(note.content)
                            .markdownTheme(HighlightedMarkdownTheme.theme)
                            .padding(8)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color(.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding(8)
            }
        }
    }
}
