import Foundation

struct RequestAnswerNotification {
    var fromId: String?;
    var notificationType: String?;
    var date: String?;
    var fromName: String?;
    var id: String?;
    
    init(dic: [String: Any]) {
        fromId = dic["fromId"] as? String;
        notificationType = dic["type"] as? String;
        date = dic["date"] as? String;
        fromName = dic["fromString"] as? String;
        id = dic["_id"] as? String;
    }
}
