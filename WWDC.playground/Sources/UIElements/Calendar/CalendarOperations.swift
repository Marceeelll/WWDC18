import Foundation

public class CalendarOperations {
    // MARK: - Instance Variable
    public lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale.autoupdatingCurrent
        return cal
    }()
    
    
    // MARK: - Type Methods
    public func getFirstDay(of month: Int, in year: Int) -> Date? {
        let date = getDate(for: 1, month: month, year: year)
        return date
    }
    
    public func getDate(for day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        let date = calendar.date(from: dateComponents)
        return date
    }
    
    public func getDay(of date: Date) -> Int {
        let day = calendar.component(.day, from: date)
        return day
    }
    
    public func getWeekday(from date: Date) -> Int {
        let weekdayNumber = calendar.component(.weekday, from: date)
        return weekdayNumber
    }
    
    public func getDateBefore(date: Date) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = -1
        let yesterday = calendar.date(byAdding: dateComponents, to: date)
        return yesterday
    }
    
    public func getDateAfter(date: Date) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let tomorrow = calendar.date(byAdding: dateComponents, to: date)
        return tomorrow
    }
    
    public func getDate(numberOfDaysShift: Int, date: Date) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDaysShift
        let yesterday = calendar.date(byAdding: dateComponents, to: date)
        return yesterday
    }
    
    public func generateDatesForSixWeek(in date: Date, startWeekOn weekday: UICalendarWeekday) -> [Date] {
        let dateComponents = calendar.dateComponents([.month, .year], from: date)
        
        guard let month = dateComponents.month, let year = dateComponents.year  else { return [] }
        
        return generateDatesForSixWeek(month: month, in: year, startWeekOn: weekday)
    }
    
    public func generateDatesForSixWeek(month: Int, in year: Int, startWeekOn weekday: UICalendarWeekday) -> [Date] {
        var monthDates = generateDates(for: month, in: year)
        guard let firstDayInMonth = monthDates.first else {
            return []
        }
        
        let numberOfWeekdays = 7
        let numberOfWeeksToGenerate = 6
        let numberOfDaysToGenerate = numberOfWeeksToGenerate * numberOfWeekdays
        let calendarStartWeekday = weekday.rawValue
        
        var firstDayInArray = getWeekday(from: firstDayInMonth)
        
        // fill with necessary `Date` from previous month
        while (firstDayInArray % (numberOfWeekdays + 1) != calendarStartWeekday) {
            let firstDateInArray = monthDates[0]
            if let aDayBefore = getDateBefore(date: firstDateInArray) {
                monthDates.insert(aDayBefore, at: 0)
                firstDayInArray = getWeekday(from: aDayBefore)
            }
        }
        
        // fill with necessary `Date` from next month
        while (monthDates.count < numberOfDaysToGenerate) {
            if let lastDateInArray = monthDates.last,
                let nextDay = getDateAfter(date: lastDateInArray){
                monthDates.append(nextDay)
            }
        }
        
        return monthDates
    }
    
    /**
     - returns:
     A array with `Date` objects for a spezific month and year.
     */
    public func generateDates(for month: Int, in year: Int) -> [Date] {
        guard let monthDate = getFirstDay(of: month, in: year),
            let dayRange = calendar.range(of: .day, in: .month, for: monthDate) else {
                return []
        }
        
        var monthDates: [Date] = []
        
        for day in dayRange.lowerBound..<dayRange.upperBound {
            if let date = getDate(for: day, month: month, year: year) {
                monthDates.append(date)
            }
        }
        
        return monthDates
    }
    
    /**
     For example, for English in the Gregorian calendar, returns `"October"`.
     */
    public func getMonthName(from date: Date) -> String {
        let months = calendar.monthSymbols
        let monthNumber = getMonth(from: date)
        let month = months[monthNumber-1]
        return month
    }
    
    public func getYear(from date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        return year
    }
    
    public func getMonth(from date: Date) -> Int {
        let month = calendar.component(.month, from: date)
        return month
    }
    
    public func isSelectedMonth(dateToCheck date: Date, selectedMonth: Date) -> Bool {
        return getMonth(from: date) == getMonth(from: selectedMonth)
    }
    
    public func isToday(date: Date) -> Bool {
        let today = Date()
        return getDay(of: date) == getDay(of: today)
            && getMonth(from: date) == getMonth(from: today)
            && getYear(from: date) == getYear(from: today)
    }
    
    /**
     For example, for English in the Gregorian calendar, returns `["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].
     */
    public func getShortWeekdayName(from date: Date) -> String {
        let weekdays = calendar.shortWeekdaySymbols
        let weekdayNumber = getWeekday(from: date)
        let weekday = weekdays[weekdayNumber-1]
        return weekday
    }
    
    
    // MARK: - Werden noch nicht verwendet
    private func getWeekdayName(from date: Date) -> String {
        let weekdays = calendar.weekdaySymbols
        let weekdayNumber = getWeekday(from: date)
        let weekday = weekdays[weekdayNumber-1]
        return weekday
    }
    
    private func numberOfDaysInLastMonth() -> Int {
        let today = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -1
        if let lastMonth = calendar.date(byAdding: dateComponents, to: today) {
            let rangeOfDaysInLastMonth = calendar.range(of: .day, in: .month, for: lastMonth)
            if let numberOfDaysInLastMonth = rangeOfDaysInLastMonth?.count {
                return numberOfDaysInLastMonth
            }
        }
        return 0
    }
}
