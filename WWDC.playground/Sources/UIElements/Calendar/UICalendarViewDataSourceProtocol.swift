import Foundation

/**
 The dataSource of a UICalendarView.
 */
public protocol UICalendarViewDataSourceProtocol: class {
    func calendarView(cellForRowAt indexPath: IndexPath) -> UICalendarViewCell
}
