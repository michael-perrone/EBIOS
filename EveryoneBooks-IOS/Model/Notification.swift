import Foundation

struct Notification {
    var fromId: String?;
    var notificationType: String?;
    var date: String?;
    var fromName: String?;
    var id: String?;
    var potentialServices: [String]?
    var potentialStartTime: String?
    var potentialDate: String?
    var potentialEmployeeId: String?
    
    init(dic: [String: Any]) {
        fromId = dic["fromId"] as? String;
        notificationType = dic["type"] as? String;
        date = dic["date"] as? String;
        fromName = dic["fromString"] as? String;
        id = dic["_id"] as? String;
        potentialServices = dic["ps"] as? [String];
        potentialStartTime = dic["potentialStartTime"] as? String;
        potentialDate = dic["potentialDate"] as? String;
        potentialEmployeeId = dic["potentialEmployee"] as? String;
    }
}
