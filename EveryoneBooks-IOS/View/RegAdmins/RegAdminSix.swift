import UIKit

class RegAdminSix: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weekdayText: UITextView = {
        let uitv = Components().createSimpleText(text: "Enter Weekend Open/Close");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let mondayRow: DayRow = {
        let dayRow = DayRow(dayName: "Mon:")
        return dayRow;
    }()
    
    private let tuesdayRow: DayRow = {
        let dayRow = DayRow(dayName: "Tue:");
        return dayRow;
    }()
    
    private let wednesdayRow: DayRow = {
        let dayRow = DayRow(dayName: "Wed:")
        return dayRow;
    }()
    
    private let thursdayRow: DayRow = {
        let dayRow = DayRow(dayName: "Thu:");
        return dayRow;
    }()
    
    private let fridayRow: DayRow = {
        let dayRow = DayRow(dayName: "Fri:");
        return dayRow;
    }()
    
    func getMonOpen() -> String {
        return mondayRow.getOpen();
    }
    
    func getMonClose() -> String {
        return mondayRow.getClose();
    }
    
    func getTueOpen() -> String {
        return tuesdayRow.getOpen();
    }
    
    func getTueClose() -> String {
        return tuesdayRow.getClose();
    }
    func getWedOpen() -> String {
        return wednesdayRow.getOpen();
    }
    
    func getWedClose() -> String {
        return wednesdayRow.getClose();
    }
    
    func getThuOpen() -> String {
        return thursdayRow.getOpen();
    }
    
    func getThuClose() -> String {
        return thursdayRow.getClose();
    }
    
    func getFriOpen() -> String {
          return fridayRow.getOpen();
    }
      
    func getFriClose() -> String {
          return fridayRow.getClose();
    }
    
    
    
    
    func configureView() {
        backgroundColor = .mainLav;
        
        addSubview(weekdayText);
        weekdayText.padTop(from: topAnchor, num: 10);
        weekdayText.centerTo(element: centerXAnchor);
        
        addSubview(mondayRow);
        mondayRow.padTop(from: weekdayText.bottomAnchor, num: 5);
        mondayRow.centerTo(element: centerXAnchor);
        
        addSubview(tuesdayRow)
        tuesdayRow.padTop(from: mondayRow.bottomAnchor, num: 5);
        tuesdayRow.centerTo(element: centerXAnchor);
        
        addSubview(wednesdayRow)
        wednesdayRow.padTop(from: tuesdayRow.bottomAnchor, num: 5);
        wednesdayRow.centerTo(element: centerXAnchor);

        addSubview(thursdayRow)
        thursdayRow.padTop(from: wednesdayRow.bottomAnchor, num: 5);
        thursdayRow.centerTo(element: centerXAnchor);
        
        addSubview(fridayRow)
        fridayRow.padTop(from: thursdayRow.bottomAnchor, num: 5);
        fridayRow.centerTo(element: centerXAnchor);
        
      
        setHeight(height: UIScreen.main.bounds.height / 1.2);
    }
}
