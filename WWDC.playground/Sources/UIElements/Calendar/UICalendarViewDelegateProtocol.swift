import UIKit

/**
 The delegate of a UICalendarView.
 */
public protocol UICalendarViewDelegateProtocol: class {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date)
    func calenderView(_ calendarView: UICalendarView, touchedPreviousMonthButton: UIButton)
    func calenderView(_ calendarView: UICalendarView, touchedNextMonthButton: UIButton)
}
