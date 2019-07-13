import Foundation

class FileNotebook {
    private var privateNotes: [Note]

    var notes : [Note] { return privateNotes }

    public init() {
        privateNotes = []
    }

    func add(_ note: Note) {
        let index = privateNotes.firstIndex { $0.uid == note.uid }

        if index == nil {
            privateNotes.append(note)
        }
    }

    func remove(with uid: String) {
        let index = privateNotes.firstIndex { $0.uid == uid }

        if let index = index {
            privateNotes.remove(at: index)
        }
    }

    func saveTo(file: String) {
        do {
            let directoryUrl = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileUrl = directoryUrl.appendingPathComponent(file)
            let jsx: [[String: Any]] = privateNotes.map { $0.json }
            let jsdata = try JSONSerialization.data(withJSONObject: jsx, options: [])

            try jsdata.write(to: fileUrl)
        } catch {
            print(error)
        }
    }

    func loadFrom(file: String) {
        do {
            let directoryUrl = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            let fileUrl = directoryUrl.appendingPathComponent(file)
            let jsdata = try Data(contentsOf: fileUrl)
            let parsedJson = try JSONSerialization.jsonObject(with: jsdata, options: []) as! [[String: Any]]

            privateNotes = parsedJson.compactMap { Note.parse(json: $0) }
        } catch {
            print(error)
        }
    }
}
