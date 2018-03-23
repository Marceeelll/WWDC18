import UIKit


public protocol UIColorPickerViewDelegate {
    func colorPicker(_ pickerView: UIPickerView, didSelectColor color: UIColor)
}

public class UIColorPickerView: UIPickerView {
    public var colors: [UIColor] = [UIColor.red, .green, .blue, .yellow]
    
    public var colorDelegate: UIColorPickerViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup() {
        self.dataSource = self
        self.delegate = self
    }
}

extension UIColorPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
}

extension UIColorPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedColor = getColor(atIndex: row)
        colorDelegate?.colorPicker(self, didSelectColor: selectedColor)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var colorView: UIView
        
        if let reusedView = view {
            colorView = reusedView
        } else {
            colorView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: 20, height: 20))
        }
        
        let color = getColor(atIndex: row)
        colorView.backgroundColor = color
        
        return colorView
    }
    
    public func getColor(atIndex index: Int) -> UIColor {
        return colors[index]
    }
}
