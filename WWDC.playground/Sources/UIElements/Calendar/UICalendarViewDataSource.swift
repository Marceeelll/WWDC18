import UIKit

/**
 The UICalendarViewDataSource protocol is adopted by an object that mediates the application’s data model for a UICalendarView object.
 */
public class UICalendarViewDataSource: NSObject, UICalendarViewDataSourceProtocol {
    // MARK: - Instance Variable
    public let numberOfWeekdays = 7
    
    public var startWeekOn: UICalendarWeekday = .sunday
    
    private (set)var current: Date!
    private var currentMonth: Int
    private var currentYear: Int
    
    public var monthDays: [Date] = []
    
    public var numberOfWeeks : Int {
        return monthDays.count / 7
    }
    
    public var datesWithEvent: [Date] = []
    
    
    // MARK: - Controller
    public let calendarOperations = CalendarOperations()
    
    
    // MARK: - Initializer
    public override init() {
        let today = Date()
        let month = calendarOperations.getMonth(from: today)
        let year = calendarOperations.getYear(from: today)
        self.currentMonth = month
        self.currentYear = year
        self.current = today
        super.init()
        initializing()
    }
    
    public init?(month: Int, year: Int) {
        self.currentMonth = month
        self.currentYear = year
        
        if let currentDate = calendarOperations.getFirstDay(of: month, in: year) {
            self.current = currentDate
            super.init()
            initializing()
        } else {
            return nil
        }
    }
    
    public func initializing() {
        generateMonthDays()
    }
    
    
    // MARK: - Updating the CalendarView
    public func nextMonth() {
        currentMonth += 1
        correctMonth()
        if let currentDate = calendarOperations.getFirstDay(of: currentMonth, in: currentYear) {
            self.current = currentDate
            initializing()
        }
    }
    
    public func previousMonth() {
        currentMonth -= 1
        correctMonth()
        if let currentDate = calendarOperations.getFirstDay(of: currentMonth, in: currentYear) {
            self.current = currentDate
            initializing()
        }
    }
    
    
    // MARK: - Getting Calendar Information
    public func getDate(at indexPath: IndexPath) -> Date {
        let date = monthDays[indexPath.day + (indexPath.week*numberOfWeekdays)]
        return date
    }
    
    public func getCurrentMonth() -> String {
        let currentMonth = calendarOperations.getMonthName(from: current)
        return currentMonth
    }
    
    public func getCurrentYear() -> Int {
        return currentYear
    }
    
    
    // MARK: - Configuring a Table View
    public func calendarView(cellForRowAt indexPath: IndexPath) -> UICalendarViewCell {
        let date = getDate(at: indexPath)
        let cellDateDay = calendarOperations.getDay(of: date)
        
        let cell = UICalendarViewCell()
        cell.date = date
        
        cell.dateLabel.text = "\(cellDateDay)"
        
        let isSelectedMonth = calendarOperations.isSelectedMonth(dateToCheck: date, selectedMonth: current)
        let isAEventDate = hasEvent(onDate: date)
        let isToday = calendarOperations.isToday(date: date)
        
        cell.set(isSelectedMonth: isSelectedMonth, hasEvent: isAEventDate, isToday: isToday)
        
        cell.backgroundColor = isEvenCell(indexPath: indexPath) ? AppColor.Calendar.evenDay : AppColor.Calendar.oddDay
        
        return cell
    }
    
    
    // MARK: - Help Methods
    private func generateMonthDays() {
        let sixWeeksDateArray = calendarOperations.generateDatesForSixWeek(in: current, startWeekOn: startWeekOn)
        monthDays = sixWeeksDateArray
    }
    
    private func correctMonth() {
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        } else if currentMonth <= 0 {
            currentMonth = 12
            currentYear -= 1
        }
    }
    
    private func isEvenCell(indexPath: IndexPath) -> Bool {
        return (indexPath.row + indexPath.section) % 2 == 0
    }
    
    private func hasEvent(onDate date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        for eventDate in datesWithEvent {
            if dateFormatter.string(from: eventDate) == dateString {
                return true
            }
        }
        return false
    }
}
