import UIKit

class EmployeeDropdown: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var chooseEmployeeDelegate: SelectEmployeeProtocol?;

    var employees: [Employee] = [] {
        didSet {
            if employees.count > 0 {
                selectedItem = employees[0];
                chooseEmployeeDelegate?.chooseEmployee(employee: employees[0]);
                DispatchQueue.main.async {
                    self.selectRow(0, inComponent: 0, animated: true)
                }
            }
            DispatchQueue.main.async {
                self.reloadAllComponents()
            }
        }
    }
    
    var selectedItem: Employee?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataSource = self;
        delegate = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employees.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if employees.count > 0 {
            return employees[row].fullName;
        }
        else {
            return "Not Good"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if employees.count > 0 {
            self.selectedItem = employees[row];
            print(employees[row]);
            chooseEmployeeDelegate?.chooseEmployee(employee: employees[row]);
        }
    }
}
