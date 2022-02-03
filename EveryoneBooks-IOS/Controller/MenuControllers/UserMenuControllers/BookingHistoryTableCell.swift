import UIKit

class BookingHistoryTableCell: UITableViewCell {
    
    var booking: Booking? {
        didSet {
            servicesTable.servicesChosen = self.booking?.serviceNames;
            timeText.text = "Time: " + self.booking!.time!;
            businessText.text = "At: " + self.booking!.businessName!;
            dateText.text = "Date: " + self.booking!.date!;
            employeeNameText.text = "With: " +  self.booking!.employeeName!;
            costText.text = "Cost: " + self.booking!.cost!;
        }
    }
    
    private let servicesText = Components().createLittleText(text: "Services");
    
    private let servicesTable: ServicesChosenTable = {
        let sct = ServicesChosenTable();
        sct.backgroundColor = .mainLav;
        sct.fontSize = 14;
        return sct;
    }()
    
    
    weak var viewClickedDelegate: UserBookingViewClicked?;
    
    private let timeText = Components().createLittleText(text: "");
    
    private let businessText = Components().createLittleText(text: "");
    
    private let dateText = Components().createLittleText(text: "");
    
    private let employeeNameText = Components().createLittleText(text: "")
    
    private let costText = Components().createLittleText(text: "");
    
    private let bottomBorder = Components().createBorder(height: 0.5, width: fullWidth, color: .darkGray2)
    
    
    func configureCell() {
        backgroundColor = .mainLav;
        selectionStyle = .none;
        setHeight(height: 290);
        addSubview(dateText);
        dateText.padLeft(from: leftAnchor, num: 8);
        dateText.padTop(from: topAnchor, num: 8);
        addSubview(businessText);
        businessText.padLeft(from: leftAnchor, num: 8);
        businessText.padTop(from: dateText.bottomAnchor, num: 20);
        businessText.setWidth(width: fullWidth / 2.1);
        addSubview(timeText);
        timeText.padLeft(from: leftAnchor, num: 8);
        timeText.padTop(from: businessText.bottomAnchor, num: 20);
        addSubview(employeeNameText);
        employeeNameText.padTop(from: timeText.bottomAnchor, num: 20);
        employeeNameText.padLeft(from: leftAnchor, num: 8);
        employeeNameText.setWidth(width: fullWidth / 2.1);
        addSubview(costText);
        costText.padTop(from: employeeNameText.bottomAnchor, num: 20);
        costText.padLeft(from: leftAnchor, num: 8);
        addSubview(servicesTable);
        servicesTable.padLeft(from: businessText.rightAnchor, num: 20);
        servicesTable.padTop(from: topAnchor, num: 50);
        servicesTable.setHeight(height: 210);
        servicesTable.setWidth(width: 180);
        servicesTable.backColor = .mainLav;
        addSubview(servicesText);
        servicesText.centerTo(element: servicesTable.centerXAnchor);
        servicesText.padTop(from: topAnchor, num: 3);
        addSubview(bottomBorder);
        bottomBorder.centerTo(element: centerXAnchor);
        bottomBorder.padBottom(from: bottomAnchor, num: 0);
    }
    
}
