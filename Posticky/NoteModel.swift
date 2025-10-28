import Foundation
import SwiftUI
import SwiftData

@Model
final class Note {
    var title: String
    var content: String
    var creationDate: Date
    
    init(title: String = "New Note", content: String = "") {
        self.title = title
        self.content = content
        self.creationDate = Date()
    }
}
