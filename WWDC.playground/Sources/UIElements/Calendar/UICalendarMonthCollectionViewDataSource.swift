import UIKit

/**
 The month in a collection view is a collection view with many cells. Each cell displays a month.
 
 Currently the collection view contains only one view, which doesnt allow to scroll inside the collection view.
 
 // TODO: ✅ Mehre Views, damit im Kalender hin und her gewischt werden kann, um die Monate zu wechseln.
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
    
    /**
     Da die UICollectionViewCell reused wird würde ohne die folgende Methode jedesmal den Kalender erneut der View hinzufügen.
     
     Deshalb wird überprüft ob sich die der Calender (was in diesem Fall eine UIStackView ist) auf der view befindet und dementsprechend gelöscht.
     
     TODO: ✅ nicht von der View entfernen sondern den Kalender mit den neuen werten updaten.
     */
    public func removeOldCalendarStackView(in cell: UICollectionViewCell) {
        for subview in cell.subviews {
            if let stackView = subview as? UIStackView {
                stackView.removeFromSuperview()
            }
        }
    }
}




