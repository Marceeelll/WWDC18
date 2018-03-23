import Foundation

public enum UICalendarWeekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    /**
     Gibt ein Arrray mit den Wochentagen zurück, beginnend mit dem Wochentag, der als Parameter übergeben wird.
     */
    public static func weekdays(beginnAt calendarWeekday: UICalendarWeekday) -> [String] {
        var result: [String] = []
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        for index in calendarWeekday.rawValue...7 {
            let weekdayName = weekdays[index-1]
            result.append(weekdayName)
        }
        for index in 1..<calendarWeekday.rawValue {
            let weekdayName = weekdays[index-1]
            result.append(weekdayName)
        }
        
        return result
    }
}
