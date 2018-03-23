import UIKit

extension IndexPath {
    var day: Int {
        return row
    }
    var week: Int {
        return section
    }
    
    init(day: Int, week: Int) {
        self = IndexPath(row: day, section: week)
    }
}


public extension UIImageView {
    public func dyeImage(imageColor: UIColor) {
        let coloredImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = imageColor
        self.image = coloredImage
    }
}
