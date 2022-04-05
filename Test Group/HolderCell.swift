import UIKit


class HolderCell: UICollectionViewCell {
    
    
    private let leftBorder = Components().createBorder(height: fullHeight - 175, width: 0.5, color: .black);
    private let rightBorder = Components().createBorder(height: fullHeight - 175, width: 0.5, color: .black);
    private let textBorder = Components().createBorder(height: 0.5, width: 180, color: .black);
    
    weak var bookingClickedDelegate: BookingClickedProtocol?
    
    private var date: String? {
        didSet {
           // columnTableView.setDate(date: self.date!);
        }
    }
    
    
    private let roomText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.setHeight(height: 30);
        uitv.backgroundColor = .white;
        return uitv;
    }()
    
    private var bcn: String? {
        didSet {
           setBcn(bcn: self.bcn!);
        }
    }
    
    func setBcn(bcn: String) {
        self.bcn = bcn;
    }
    
    func getBcn() -> Int {
        return Int(self.bcn!)!
    }

    
    
    func setRoomText(text: String) {
        roomText.text = text;
    }
    

    


//    private let columnTableView: ColumnTableView = {
//        let ctv = ColumnTableView();
//        return ctv;
//    }()
//
    
    private let columnScrollView: ColumnScrollView = {
        let csv = ColumnScrollView();
        return csv;
    }()
    
    func configureCell() {
       // columnTableView.bookingClickedDelegate = bookingClickedDelegate;
       // testSchedule.heightDelegate = self;
        
        backgroundColor = .white;
        addSubview(leftBorder);
        leftBorder.padLeft(from: leftAnchor, num: 0);
        leftBorder.padTop(from: topAnchor, num: 0);
        addSubview(rightBorder);
        rightBorder.padRight(from: rightAnchor, num: 0);
        rightBorder.padTop(from: topAnchor, num: 0);
        addSubview(roomText);
        roomText.padTop(from: topAnchor, num: fullHeight > 800 ? 50 : 20 );
        roomText.centerTo(element: centerXAnchor);
        
        addSubview(columnScrollView);
        columnScrollView.padTop(from: roomText.bottomAnchor, num: 10);
        columnScrollView.padLeft(from: leftAnchor, num: 2);
        columnScrollView.padRight(from: rightAnchor, num: 2);
        columnScrollView.padBottom(from: safeAreaLayoutGuide.bottomAnchor, num: 20);
//      addSubview(columnTableView);
//        columnTableView.padTop(from: roomText.bottomAnchor, num: 10);
//        columnTableView.padLeft(from: leftAnchor, num: 2);
//        columnTableView.padRight(from: rightAnchor, num: 2);
//        columnTableView.padBottom(from: safeAreaLayoutGuide.bottomAnchor, num: 20);
//        columnTableView.setBookings(bookings: []);
        addSubview(textBorder);
//        textBorder.padBottom(from: columnTableView.topAnchor, num: 0.5);
        textBorder.padBottom(from: columnScrollView.topAnchor, num: 0);
        
        textBorder.padRight(from: rightAnchor, num: 2);
        textBorder.padLeft(from: leftAnchor, num: 2);
        
    }
}
