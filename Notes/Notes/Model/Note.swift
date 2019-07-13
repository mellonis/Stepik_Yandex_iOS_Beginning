import UIKit

enum Importance: String {
    case insignificant
    case usual
    case critical
}

struct Note {
    public let uid: String
    public let title: String
    public let content: String
    public let color: UIColor
    public let importance: Importance
    public let selfDestructDate: Date?
    
    public init(
        uid: String = UUID().uuidString,
        title: String,
        content: String,
        color: UIColor = .white,
        importance: Importance,
        selfDestructDate: Date? = nil
    ) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructDate = selfDestructDate
    }
}

