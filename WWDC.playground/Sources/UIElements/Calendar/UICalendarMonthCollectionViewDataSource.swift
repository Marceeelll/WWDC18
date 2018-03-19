import UIKit

/**
 The month in a collection view is a collection view with many cells. Each cell displays a month.
 
 Currently the collection view contains only one view, which doesnt allow to scroll inside the collection view.
 
 */
public class UICalendarMonthCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var calendarView: UICalendarView!
    
    
    public init(calendarView: UICalendarView) {
        self.calendarView = calendarView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        removeOldCalendarStackView(in: cell)
        
        let monthCells = calendarView.createCalendarCellView()
        cell.addSubview(monthCells)
        ConstraintAssistant.addConstraints(on: monthCells, andMatchTheSameSizeAsView: cell)
        
        return cell
    }
    
    public func removeOldCalendarStackView(in cell: UICollectionViewCell) {
        for subview in cell.subviews {
            if let stackView = subview as? UIStackView {
                stackView.removeFromSuperview()
            }
        }
    }
}




