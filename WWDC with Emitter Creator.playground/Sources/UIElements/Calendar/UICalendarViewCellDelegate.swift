import Foundation

/**
 The delegate of a UICalendarViewCell.
 */
public protocol UICalendarViewCellDelegate: class {
    func calendarViewCell(_ didSelectedCalendarViewCell: UICalendarViewCell)
}
