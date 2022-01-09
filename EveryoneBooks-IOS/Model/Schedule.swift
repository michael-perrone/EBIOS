import Foundation
import UIKit

struct Schedule {

    let sunOpen: String;
    let sunClose: String;
    let monOpen: String;
    let monClose: String;
    let tueOpen: String;
    let tueClose: String;
    let wedOpen: String;
    let wedClose: String;
    let thuOpen: String;
    let thuClose: String;
    let friOpen: String;
    let friClose: String;
    let satOpen: String;
    let satClose: String;
    
    init(dic: [[String:String]]) {
        sunOpen = dic[0]["open"]!;
        sunClose = dic[0]["close"]!;
        monOpen = dic[1]["open"]!;
        monClose = dic[1]["close"]!;
        tueOpen = dic[2]["open"]!;
        tueClose = dic[2]["close"]!;
        wedOpen = dic[3]["open"]!;
        wedClose = dic[3]["close"]!;
        thuOpen = dic[4]["open"]!;
        thuClose = dic[4]["close"]!;
        friOpen = dic[5]["open"]!;
        friClose = dic[5]["close"]!;
        satOpen = dic[6]["open"]!;
        satClose = dic[6]["close"]!;


    }
}
