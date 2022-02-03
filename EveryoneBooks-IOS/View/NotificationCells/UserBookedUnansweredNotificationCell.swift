import UIKit

class UserBookedUnansweredNotificationCell: UserBookedNotificationCell {
    
    @objc func hit() {
        if Utilities().getAdminToken() != "nil" {
            if let noti = noti {
                ubDel?.tappedUserBooked(noti: noti)
            }
        }
        else if Utilities().getEmployeeToken() != "nil" {
            if let noti = noti {
                ubDelEmployee?.tappedUserBooked(noti: noti)
            }
        }
    }
    
    @objc func printHi() {
        print("weewaw");
    }
    
    weak var ubDel: UserBookedCellProtocol? {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
            notiMessage.addGestureRecognizer(tap);
        }
    }
    
    weak var ubDelEmployee: UserBookedCellProtocolEmployee? {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
            notiMessage.addGestureRecognizer(tap);
        }
    }

    func layoutUnread() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
        contentView.addGestureRecognizer(tap);
        addSubview(closeEnv);
        closeEnv.padLeft(from: leftAnchor, num: 10);
        closeEnv.padTop(from: topAnchor, num: 33);
        if Utilities().getAdminToken() != "nil" {
            notiMessage.text = "Your business has an Unanswered Booking Request.";
        }
        else if Utilities().getEmployeeToken() != "nil" {
            notiMessage.text = "You have an unanswered booking request."
        }
    }
}
