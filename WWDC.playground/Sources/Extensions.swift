import Foundation

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
