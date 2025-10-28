//
//  ContentView.swift
//  MarkdownStickies
//
//  Created by Zian Chen on 10/27/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // Access the database context from the environment
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Note.creationDate, order: .reverse) private var notes: [Note]
    
    // Use the persistent model identifier for stable selection
    @State private var selectedID: PersistentIdentifier?
    
    // Function to add a new note
    func addNote() {
        // The creationDate is set automatically in the Note initializer
        let newNote = Note(title: "New Note \(notes.count + 1)", content: "")
        modelContext.insert(newNote) // Insert into the database
        // Select the new note by its persistent ID
        selectedID = newNote.persistentModelID
    }
    
    // Function to delete the selected note
    func deleteSelectedNote() {
        guard let id = selectedID,
              let noteToDelete = modelContext.model(for: id) as? Note
        else { return }
        modelContext.delete(noteToDelete) // Delete from the database
        selectedID = nil // Clear selection after deletion
    }
    
    var body: some View {
        // Use NavigationSplitView for the master-detail layout
        NavigationSplitView { // SIDEBAR (Left Panel)
            List(selection: $selectedID) {
                ForEach(notes) { note in
                    // Display the note title in the list
                    Text(note.title)
                        .lineLimit(1)
                        .tag(note.persistentModelID)
                }
            }
            .navigationTitle("Notes")
            // Add a toolbar button to create new notes
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: addNote) {
                        Label("Add Note", systemImage: "square.and.pencil")
                    }
                }
                // Add a delete button to the sidebar
                ToolbarItem(placement: .automatic) {
                    Button(action: deleteSelectedNote) {
                        Label("Delete Note", systemImage: "trash")
                    }
                    // Disable delete button if no note is selected
                    .disabled(selectedID == nil)
                }
            }
            .listStyle(.sidebar) // Give it the standard macOS sidebar look
            
        } detail: { // DETAIL VIEW (Right Panel)
            if let id = selectedID,
               let note = modelContext.model(for: id) as? Note {
                NoteDetailView(note: note)
            } else {
                Text("Select a note or tap '+' to create a new one.")
                    .foregroundColor(.secondary)
            }
        }
        // Set minimum size for the entire window
        .frame(minWidth: 700, minHeight: 400)
    }
}

// Preview provider for design mode (only for development in Xcode)
#Preview {
    ContentView().modelContainer(for: Note.self)
}
