import UIKit




public class FoldableData {
    public var data: Attribute
    public var foldableItems: [String]
    public var isUnfolded: Bool = false
    
    public init(data: Attribute, foldableItems: [String] = []) {
        self.data = data
        self.foldableItems = foldableItems
    }
    
    public func isFoldable() -> Bool {
        return !foldableItems.isEmpty
    }
    
    public func numberOfFoldableElements() -> Int {
        return foldableItems.count
    }
}



public protocol UIFoldableTableViewDelegate: class {
    func foldableTableView(didSelectUnfoldedRowAt indexPath: IndexPath)
}

open class UIFoldableTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    public var sections: [String] = []
    public var elements: [[FoldableData]] = []
    private var selectedIndexPath: IndexPath?
    private var unfoldedIndexPaths: [IndexPath] = []
    
    public var foldableDelegate: UIFoldableTableViewDelegate?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        dataSource = self
        delegate = self
    }
    
    // MARK - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isUnfoldedCell(atIndexPath: indexPath) {
            foldableDelegate?.foldableTableView(didSelectUnfoldedRowAt: indexPath)
        } else {
            let selectedFoldedElement = getElement(atIndexPath: indexPath)
            if selectedFoldedElement.isFoldable() {
                let foldBeforeUnfold = selectedIndexPath != indexPath && selectedIndexPath != nil
                let oldSelectedIndexPath = selectedIndexPath
                selectedIndexPath = indexPath
                
                if selectedFoldedElement.isUnfolded {
                    selectedFoldedElement.isUnfolded = false
                    fold()
                } else {
                    var indexPath: IndexPath = indexPath
                    if foldBeforeUnfold {
                        if let oldSelectedIndexPath = oldSelectedIndexPath {
                            if oldSelectedIndexPath.section == indexPath.section && oldSelectedIndexPath.row < indexPath.row {
                                indexPath = IndexPath(row: indexPath.row - unfoldedIndexPaths.count,
                                                      section: oldSelectedIndexPath.section)
                            }
                            let oldSelectedElement = getElement(atIndexPath: oldSelectedIndexPath)
                            oldSelectedElement.isUnfolded = false
                            fold()
                        }
                    }
                    selectedFoldedElement.isUnfolded = true
                    unfold(atIndexPath: indexPath)
                }
            } else {
                if let oldSelectedIndexPath = selectedIndexPath {
                    let oldSelectedElement = getElement(atIndexPath: oldSelectedIndexPath)
                    oldSelectedElement.isUnfolded = false
                    fold()
                }
            }
        }
    }
    
    // MARK: - Fold
    private func fold() {
        let indexPathsToDelete = unfoldedIndexPaths
        unfoldedIndexPaths = []
        self.deleteRows(at: indexPathsToDelete, with: .right)
        selectedIndexPath = nil
    }
    
    public func fold(atIndexPath indexPath: IndexPath) {
        let element = getElement(atIndexPath: indexPath)
        element.isUnfolded = false
        fold()
    }
    
    
    // MARK: - Unfold
    private func unfold(atIndexPath indexPath: IndexPath) {
        unfoldedIndexPaths = []
        selectedIndexPath = indexPath
        
        createUnfoldIndexPaths(ofSelectedIndexPath: indexPath)
        self.insertRows(at: unfoldedIndexPaths, with: .left)
    }
    
    private func createUnfoldIndexPaths(ofSelectedIndexPath indexPath: IndexPath) {
        let selectedElement = getElement(atIndexPath: indexPath)
        let numberOfUnfoldingSections = selectedElement.foldableItems.count
        if numberOfUnfoldingSections > 0 {
            for index in 1...numberOfUnfoldingSections {
                let unfoldingIndexPath = IndexPath(row: indexPath.row + index, section: indexPath.section)
                unfoldedIndexPaths.append(unfoldingIndexPath)
            }
        }
    }
    
    
    // MARK: - Hilfsmethoden
    public func isUnfoldedCell(atIndexPath indexPath: IndexPath) -> Bool {
        return unfoldedIndexPaths.contains(indexPath)
    }
    
    public func getUnfoldedElement(atIndexPath indexPath: IndexPath) -> String {
        let element = getElement(atIndexPath: indexPath)
        var adjustedIndex = indexPath.row
        if let firstUnfoldedIndexPath = unfoldedIndexPaths.first {
            if firstUnfoldedIndexPath.row <= indexPath.row {
                adjustedIndex -= firstUnfoldedIndexPath.row
            }
        }
        return element.foldableItems[adjustedIndex]
    }
    
    public func getElement(atIndexPath indexPath: IndexPath) -> FoldableData {
        let section = indexPath.section
        var row = indexPath.row
        
        if !isUnfoldedCell(atIndexPath: indexPath) {
            if indexPath.row > elements[section].count {
                row = indexPath.row - unfoldedIndexPaths.count
            } else if indexPath.row == elements[section].count {
                row = indexPath.row - 1
            }
            return elements[section][row]
        } else {
            if let selectedIndexPath = selectedIndexPath {
                row = selectedIndexPath.row
                return elements[section][row]
            }
        }
        
        return elements[section][0]
    }
    
    
    // MARK - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = elements[section].count
        for foldableData in elements[section] {
            if foldableData.isUnfolded {
                rows += foldableData.numberOfFoldableElements()
            }
        }
        return rows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isUnfoldedCell(atIndexPath: indexPath) {
            let unfoldedElement = getUnfoldedElement(atIndexPath: indexPath)
            cell.textLabel?.text = " • \(unfoldedElement)"
            return cell
        }
        
        let foldableData = getElement(atIndexPath: indexPath)
        cell.textLabel?.text = "\(foldableData.data)"
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
}

extension UIFoldableTableView {
    //    public func getIndexPath(ofData data: Attribute) -> IndexPath? {
    //        var sectionResult = 0
    //        var rowResult = 0
    //        for section in elements {
    //            rowResult = 0
    //            for foldableData in section {
    //                if foldableData.data == data {
    //                    let foundIndexPath = IndexPath(row: rowResult, section: sectionResult)
    //                    return foundIndexPath
    //                }
    //                rowResult += 1
    //            }
    //            sectionResult += 1
    //        }
    //        return nil
    //    }
}

extension UIFoldableTableView {
    public func getParentIndexPath(ofData data: String) -> IndexPath? {
        var sectionResult = 0
        var rowResult = 0
        for section in elements {
            rowResult = 0
            for foldableData in section {
                for item in foldableData.foldableItems {
                    if item == data {
                        let foundIndexPath = IndexPath(row: rowResult, section: sectionResult)
                        return foundIndexPath
                    }
                }
                rowResult += 1
            }
            sectionResult += 1
        }
        return nil
    }
}

























