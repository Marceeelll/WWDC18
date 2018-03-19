import UIKit

/**
 The month in a collection view is a collection view with many cells. Each cell displays a month.
 The `UICalendarMonthCollectionViewDelegate` defines the layout how the cells are oredered and display inside the collection view.
 */
public class UICalendarMonthCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return cellSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
