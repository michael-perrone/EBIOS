//
//  File.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import JWTDecode

class Utilities {
    func setTokenInKeyChain(token: String, key: String) -> Bool {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: key);
        if let adminToken = KeychainWrapper.standard.string(forKey: "adminToken") {
            print(adminToken)
        }
        print(saveSuccessful);
        print("below save succesfful0")
        print(token)
        return saveSuccessful;
    }

    func getToken() -> String {
        if let token = KeychainWrapper.standard.string(forKey: "token") {
            return token;
         }
        else {
            return "nil"
        }
     }
     
     func getAdminToken() -> String {
        if let adminToken = KeychainWrapper.standard.string(forKey: "adminToken") {
            return adminToken;
         }
        else {
            return "nil"
        }
    }
     
     func getEmployeeToken() -> String {
        if let employeeToken = KeychainWrapper.standard.string(forKey: "employeeToken") {
            return employeeToken;
         }
        else {
            return "nil"
        }
     }
    
    func logout(key: String) {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
    
    func decodeAdminToken() -> [String: Any]? {
        do {
            let decodedToken = try decode(jwt: getAdminToken())
            let admin = decodedToken.body["admin"] as? [String: Any];
            return admin;
        } catch {
            print("could not decode token")
        }
        return nil;
    }
    
    func getBusinessId() -> String? {
        if let decodedToken = decodeAdminToken() {
            if let businessId = decodedToken["businessId"] as? String {
                return businessId;
            }
        }
        return nil;
    }
    
    func decodeEmployeeToken() -> [String: Any]? {
        do {
            let decodedToken = try decode(jwt: getEmployeeToken())
            let employee = decodedToken.body["employee"] as? [String: Any];
            return employee;
        } catch {
            print("could not decode token")
        }
        return nil;
    }
    
    func getEmployeeId() -> String? {
           if let decodedToken = decodeEmployeeToken() {
               if let employeeId = decodedToken["id"] as? String {
                   return employeeId;
               }
           }
           return nil;
       }
    
    func getUserId() -> String? {
        if let decodedToken = decodeUserToken() {
            if let userId = decodedToken["id"] as? String {
                return userId;
            }
        }
        return nil;
    }
    
    func decodeUserToken() -> [String: Any]? {
        do {
            let decodedToken = try decode(jwt: getToken())
            return decodedToken.body["user"] as? [String: Any];
        } catch {
            print("could not decode token")
        }
        return nil;
    }
    
    func slimString(stringToSlim: String) -> String {
        var stringToReturn: String;
        if stringToSlim.count > 22 {
            var correctString = stringToSlim[0..<19];
            correctString += "...";
             stringToReturn = correctString;
        }
        else {
            stringToReturn = stringToSlim;
        }
        return stringToReturn;
    }
    
    func doubleIntoDollar(num: Double) -> String {
        let numString = String(num);
        let numArray = numString.components(separatedBy: ".");
        var stringToReturn = "";
        if numArray.count == 2 {
            if numArray[1].count == 2 {
                stringToReturn = "$" + numString;
            }
            else if numArray[1].count == 0 {
                stringToReturn = "$" + numString + "00";
            }
            else if numArray[1].count == 1 {
                stringToReturn = "$" + numString + "0";
            }
        }
        else {
            stringToReturn = "$" + numString + ".00";
        }
        return stringToReturn;
    }
    
   
    
    
    static let stit: [String: Int] = ["12:00 AM": 0, "12:15 AM": 1, "12:30 AM": 2, "12:45 AM": 3, "1:00 AM": 4, "1:15 AM": 5, "1:30 AM": 6, "1:45 AM": 7, "2:00 AM": 8, "2:15 AM": 9, "2:30 AM": 10, "2:45 AM": 11, "3:00 AM": 12, "3:15 AM": 13, "3:30 AM": 14, "3:45 AM": 15, "4:00 AM": 16, "4:15 AM": 17, "4:30 AM": 18, "4:45 AM": 19, "5:00 AM": 20, "5:15 AM": 21, "5:30 AM": 22, "5:45 AM": 23, "6:00 AM": 24, "6:15 AM": 25, "6:30 AM": 26, "6:45 AM": 27, "7:00 AM": 28, "7:15 AM": 29, "7:30 AM": 30, "7:45 AM": 31, "8:00 AM": 32, "8:15 AM": 33, "8:30 AM": 34, "8:45 AM": 35, "9:00 AM": 36, "9:15 AM": 37, "9:30 AM": 38, "9:45 AM": 39, "10:00 AM": 40, "10:15 AM": 41, "10:30 AM": 42, "10:45 AM": 43, "11:00 AM": 44, "11:15 AM": 45, "11:30 AM": 46, "11:45 AM": 47, "12:00 PM": 48, "12:15 PM": 49, "12:30 PM": 50, "12:45 PM": 51, "1:00 PM": 52, "1:15 PM": 53, "1:30 PM": 54, "1:45 PM": 55, "2:00 PM": 56, "2:15 PM": 57, "2:30 PM": 58, "2:45 PM": 59, "3:00 PM": 60, "3:15 PM": 61, "3:30 PM": 62, "3:45 PM": 63, "4:00 PM": 64, "4:15 PM": 65, "4:30 PM": 66, "4:45 PM": 67, "5:00 PM": 68, "5:15 PM": 69, "5:30 PM": 70, "5:45 PM": 71, "6:00 PM": 72, "6:15 PM": 73, "6:30 PM": 74, "6:45 PM": 75, "7:00 PM": 76, "7:15 PM": 77, "7:30 PM": 78, "7:45 PM": 79, "8:00 PM": 80, "8:15 PM": 81, "8:30 PM": 82, "8:45 PM": 83, "9:00 PM": 84, "9:15 PM": 85, "9:30 PM": 86, "9:45 PM": 87, "10:00 PM": 88, "10:15 PM": 89, "10:30 PM": 90, "10:45 PM": 91, "11:00 PM": 92, "11:15 PM": 93, "11:30 PM": 94, "11:45 PM": 95]
    
    static let itst: [Int: String] = [0: "12:00 AM", 1: "12:15 AM", 2: "12:30 AM", 3: "12:45 AM", 4: "1:00 AM", 5: "1:15 AM", 6: "1:30 AM", 7: "1:45 AM", 8: "2:00 AM", 9: "2:15 AM", 10: "2:30 AM", 11: "2:45 AM", 12: "3:00 AM", 13: "3:15 AM", 14: "3:30 AM", 15: "3:45 AM", 16: "4:00 AM", 17: "4:15 AM", 18: "4:30 AM", 19: "4:45 AM", 20: "5:00 AM", 21: "5:15 AM", 22: "5:30 AM", 23: "5:45 AM", 24: "6:00 AM", 25: "6:15 AM", 26: "6:30 AM", 27: "6:45 AM", 28: "7:00 AM", 29: "7:15 AM", 30: "7:30 AM", 31: "7:45 AM", 32: "8:00 AM", 33: "8:15 AM", 34:  "8:30 AM", 35: "8:45 AM", 36: "9:00 AM", 37: "9:15 AM", 38: "9:30 AM", 39: "9:45 AM", 40: "10:00 AM", 41: "10:15 AM", 42: "10:30 AM", 43: "10:45 AM", 44: "11:00 AM", 45: "11:15 AM", 46: "11:30 AM", 47: "11:45 AM", 48: "12:00 PM", 49: "12:15 PM", 50: "12:30 PM", 51: "12:45 PM", 52: "1:00 PM", 53: "1:15 PM", 54: "1:30 PM", 55: "1:45 PM", 56: "2:00 PM", 57: "2:15 PM", 58: "2:30 PM", 59: "2:45 PM", 60: "3:00 PM", 61: "3:15 PM", 62: "3:30 PM", 63: "3:45 PM", 64: "4:00 PM", 65: "4:15 PM", 66: "4:30 PM", 67: "4:45 PM", 68: "5:00 PM", 69: "5:15 PM", 70: "5:30 PM", 71: "5:45 PM", 72: "6:00 PM", 73: "6:15 PM", 74: "6:30 PM", 75: "6:45 PM", 76: "7:00 PM", 77: "7:15 PM", 78: "7:30 PM", 79: "7:45 PM", 80: "8:00 PM", 81: "8:15 PM", 82: "8:30 PM", 83: "8:45 PM", 84: "9:00 PM", 85: "9:15 PM", 86: "9:30 PM", 87: "9:45 PM", 88: "10:00 PM", 89: "10:15 PM", 90: "10:30 PM", 91: "10:45 PM", 92: "11:00 PM", 93: "11:15 PM", 94: "11:30 PM", 95: "11:45 PM"]

    func getTimeNum(startTime: String, endTime: String) -> Int {
        let startTimeNumber = Utilities.stit[startTime];
        let endTimeNumber = Utilities.stit[endTime];
        if let start = startTimeNumber, let end = endTimeNumber {
            return end - start;
        }
        return 0;
       }
    
    static let timeDurationStringToInt: [String: Int] = [
        "15 Minutes": 1, "30 Minutes": 2, "45 Minutes": 3, "1 Hour": 4, "1 Hour 15 Minutes": 5, "1 Hour 30 Minutes": 6, "1 Hour 45 Minutes": 7, "2 Hours": 8, "2 Hours 15 Minutes": 9, "2 Hours 30 Minutes": 10, "2 Hours 45 Minutes": 11, "3 Hours": 12]
}
