import Foundation

class FileNotebook {
    private(set) var notes = [Note]()

    func add(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }

    func remove(with uid: String) {
        let index = notes.firstIndex { $0.uid == uid }

        if let index = index {
            notes.remove(at: index)
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
            let jsx: [[String: Any]] = notes.map { $0.json }
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

            notes = parsedJson.compactMap { Note.parse(json: $0) }
        } catch {
            print(error)
        }
    }
}
