import UIKit

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        switch (json["uid"], json["title"], json["content"]) {
        case let (uid as String, title as String, content as String):
            return Note(
                uid: uid,
                title: title,
                content: content,
                color: UIColor(json["color"] as! String?),
                importance: Importance(json["importance"] as! String?),
                selfDestructDate: Date(json["selfDestructDate"] as! TimeInterval?)
            )
        default:
            return nil
        }
    }
    
    var json: [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["uid"] = uid
        dict["title"] = title
        dict["content"] = content
        
        if (!color.isEqual(UIColor.white)) {
            dict["color"] = color.serialize()
        }
        
        if importance != .usual {
            dict["importance"] = importance.rawValue
        }
        
        if let selfDestructDate = selfDestructDate {
            dict["selfDestructDate"] = selfDestructDate.timeIntervalSince1970
        }
        
        return dict
    }
}

extension UIColor {
    var rgbaComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaChannel: CGFloat = 0
        
        getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaChannel)
        
        return (redComponent, greenComponent, blueComponent, alphaChannel)
    }
    
    func serialize() -> String {
        return String(
            format: "%08x",
            UInt32(rgbaComponents.r * 255) << 24
                | UInt32(rgbaComponents.g * 255) << 16
                | UInt32(rgbaComponents.b * 255) << 8
                | UInt32(rgbaComponents.a * 255)
        )
    }
    
    convenience init(_ str: String?) {
        if let str = str {
            if let color = UInt32(str, radix: 16) {
                self.init(red: CGFloat((color >> 24) & 0xff) / 255, green: CGFloat((color >> 16) & 0xff) / 255, blue: CGFloat((color >> 8) & 0xff) / 255, alpha: CGFloat(color & 0xff) / 255)
            } else {
                self.init(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

extension Importance {
    init(_ str: String?) {
        if let str = str {
            switch str {
            case "insignificant":
                self = .insignificant
            case "critical":
                self = .critical
            case "usual":
                fallthrough
            default:
                self = .usual
            }
        } else {
            self = .usual
        }
    }
}

extension Date {
    init?(_ ti: TimeInterval?) {
        if let ti = ti {
            self.init(timeIntervalSince1970: ti)
            return
        }
        
        return nil
    }
}
