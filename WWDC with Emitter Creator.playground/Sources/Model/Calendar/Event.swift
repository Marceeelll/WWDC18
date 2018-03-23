import Foundation

public struct Event {
    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var type: EventType
    public var isFullTime: Bool
    
    public init(title: String, startDate: Date, endDate: Date, type: EventType, isFullTime: Bool) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.isFullTime = isFullTime
    }
    
    public func getDatesBetweenStartAndEnd() -> [Date] {
        if let durationInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day {
            var days: [Date] = []
            for dayDuration in 0...durationInDays {
                if let day = Calendar.current.date(byAdding: .day, value: dayDuration, to: startDate) {
                    days.append(day)
                }
            }
            return days
        }
        return []
    }
    
    public func isOneDayEvent() -> Bool {
        return Calendar.current.isDate(startDate, inSameDayAs: endDate)
    }
    
    public func isDateBetweenStartAndEndDate(dateToCheck date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: min(max(startDate, date), endDate))
    }
    
    public func getTimes(forDate date: Date) -> (startTime: String, endTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        if isFullTime {
            return ("all-day", "")
        } else if isOneDayEvent() {
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            return (startTime, endTime)
        } else if Calendar.current.isDate(startDate, inSameDayAs: date) {
            let startTime = dateFormatter.string(from: startDate)
            return (startTime, "")
        } else if !Calendar.current.isDate(endDate, inSameDayAs: date) {
            return ("all-day", "")
        } else {
            let endTime = dateFormatter.string(from: endDate)
            return ("End", endTime)
        }
    }
}
