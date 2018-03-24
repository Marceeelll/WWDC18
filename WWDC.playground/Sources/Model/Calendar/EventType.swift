import UIKit

public enum EventType {
    case birthday
    case christmas
    case wwdc
    case newYear
    case holiday
    case important
    case none
    
    public static var allEventTypes: [EventType] = [EventType.birthday, .christmas, .wwdc, .newYear, .holiday, .important, .none]
    
    public var symbol: String {
        switch self {
        case .birthday: return "🎂"
        case .christmas: return "🎅"
        case .wwdc: return "👨‍💻"
        case .newYear: return "🎊"
        case .holiday: return "🌴"
        case .important: return "⚠️"
        case .none: return ""
        }
    }
    
    public var name: String {
        switch self {
        case .birthday: return "Birthday"
        case .christmas: return "Christmas"
        case .wwdc: return "WWDC 2018"
        case .newYear: return "New Year"
        case .holiday: return "Holiday"
        case .important: return "Important"
        case .none: return "No Category"
        }
    }
    
    public var color: UIColor {
        switch self {
        case .birthday: return AppColor.Apple.purple
        case .christmas: return AppColor.Apple.red
        case .wwdc: return AppColor.Apple.orange
        case .newYear: return AppColor.Apple.blue
        case .holiday: return AppColor.Apple.green
        case .important: return AppColor.Apple.yellow
        case .none: return UIColor.darkGray
        }
    }
}
