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
    
   
    
    
    static let stit: [String: Int] = ["12:00 AM": 0, "12:05 AM": 1, "12:10 AM": 2, "12:15 AM": 3, "12:20 AM": 4, "12:25 AM": 5, "12:30 AM": 6, "12:35 AM": 7, "12:40 AM": 8, "12:45 AM": 9, "12:50 AM": 10, "12:55 AM": 11, "1:00 AM": 12, "1:05 AM": 13, "1:10 AM": 14, "1:15 AM": 15, "1:20 AM": 16, "1:25 AM": 17, "1:30 AM": 18, "1:35 AM": 19, "1:40 AM": 20, "1:45 AM": 21, "1:50 AM": 22, "1:55 AM": 23, "2:00 AM": 24, "2:05 AM": 25, "2:10 AM": 26, "2:15 AM": 27, "2:20 AM": 28, "2:25 AM": 29, "2:30 AM": 30, "2:35 AM": 31, "2:40 AM": 32, "2:45 AM": 33, "2:50 AM": 34, "2:55 AM": 35, "3:00 AM": 36, "3:05 AM": 37, "3:10 AM": 38, "3:15 AM": 39, "3:20 AM": 40, "3:25 AM": 41, "3:30 AM": 42, "3:35 AM": 43, "3:40 AM": 44, "3:45 AM": 45, "3:50 AM": 46, "3:55 AM": 47, "4:00 AM": 48, "4:05 AM": 49, "4:10 AM": 50, "4:15 AM": 51, "4:20 AM": 52, "4:25 AM": 53, "4:30 AM": 54, "4:35 AM": 55, "4:40 AM": 56, "4:45 AM": 57, "4:50 AM": 58, "4:55 AM": 59, "5:00 AM": 60, "5:05 AM": 61, "5:10 AM": 62, "5:15 AM": 63, "5:20 AM": 64, "5:25 AM": 65, "5:30 AM": 66, "5:35 AM": 67, "5:40 AM": 68, "5:45 AM": 69, "5:50 AM": 70, "5:55 AM": 71, "6:00 AM": 72, "6:05 AM": 73, "6:10 AM": 74, "6:15 AM": 75, "6:20 AM": 76, "6:25 AM": 77, "6:30 AM": 78, "6:35 AM": 79, "6:40 AM": 80, "6:45 AM": 81, "6:50 AM": 82, "6:55 AM": 83, "7:00 AM": 84, "7:05 AM": 85, "7:10 AM": 86, "7:15 AM": 87, "7:20 AM": 88, "7:25 AM": 89, "7:30 AM": 90, "7:35 AM": 91, "7:40 AM": 92, "7:45 AM": 93, "7:50 AM": 94, "7:55 AM": 95, "8:00 AM": 96, "8:05 AM": 97, "8:10 AM": 98, "8:15 AM": 99, "8:20 AM": 100, "8:25 AM": 101, "8:30 AM": 102, "8:35 AM": 103, "8:40 AM": 104, "8:45 AM": 105, "8:50 AM": 106, "8:55 AM": 107, "9:00 AM": 108, "9:05 AM": 109, "9:10 AM": 110, "9:15 AM": 111, "9:20 AM": 112, "9:25 AM": 113, "9:30 AM": 114, "9:35 AM": 115, "9:40 AM": 116, "9:45 AM": 117, "9:50 AM": 118, "9:55 AM": 119, "10:00 AM": 120, "10:05 AM": 121, "10:10 AM": 122, "10:15 AM": 123, "10:20 AM": 124, "10:25 AM": 125, "10:30 AM": 126, "10:35 AM": 127, "10:40 AM": 128, "10:45 AM": 129, "10:50 AM": 130, "10:55 AM": 131, "11:00 AM": 132, "11:05 AM": 133, "11:10 AM": 134, "11:15 AM": 135, "11:20 AM": 136, "11:25 AM": 137, "11:30 AM": 138, "11:35 AM": 139, "11:40 AM": 140, "11:45 AM": 141, "11:50 AM": 142, "11:55 AM": 143, "12:00 PM": 144, "12:05 PM": 145, "12:10 PM": 146, "12:15 PM": 147, "12:20 PM": 148, "12:25 PM": 149, "12:30 PM": 150, "12:35 PM": 151, "12:40 PM": 152, "12:45 PM": 153, "12:50 PM": 154, "12:55 PM": 155, "1:00 PM": 156, "1:05 PM": 157, "1:10 PM": 158, "1:15 PM": 159, "1:20 PM": 160, "1:25 PM": 161, "1:30 PM": 162, "1:35 PM": 163, "1:40 PM": 164, "1:45 PM": 165, "1:50 PM": 166, "1:55 PM": 167, "2:00 PM": 168, "2:05 PM": 169, "2:10 PM": 170, "2:15 PM": 171, "2:20 PM": 172, "2:25 PM": 173, "2:30 PM": 174, "2:35 PM": 175, "2:40 PM": 176, "2:45 PM": 177, "2:50 PM": 178, "2:55 PM": 179, "3:00 PM": 180, "3:05 PM": 181, "3:10 PM": 182, "3:15 PM": 183, "3:20 PM": 184, "3:25 PM": 185, "3:30 PM": 186, "3:35 PM": 187, "3:40 PM": 188, "3:45 PM": 189, "3:50 PM": 190, "3:55 PM": 191, "4:00 PM": 192, "4:05 PM": 193, "4:10 PM": 194, "4:15 PM": 195, "4:20 PM": 196, "4:25 PM": 197, "4:30 PM": 198, "4:35 PM": 199, "4:40 PM": 200, "4:45 PM": 201, "4:50 PM": 202, "4:55 PM": 203, "5:00 PM": 204, "5:05 PM": 205, "5:10 PM": 206, "5:15 PM": 207, "5:20 PM": 208, "5:25 PM": 209, "5:30 PM": 210, "5:35 PM": 211, "5:40 PM": 212, "5:45 PM": 213, "5:50 PM": 214, "5:55 PM": 215, "6:00 PM": 216, "6:05 PM": 217, "6:10 PM": 218, "6:15 PM": 219, "6:20 PM": 220, "6:25 PM": 221, "6:30 PM": 222, "6:35 PM": 223, "6:40 PM": 224, "6:45 PM": 225, "6:50 PM": 226, "6:55 PM": 227, "7:00 PM": 228, "7:05 PM": 229, "7:10 PM": 230, "7:15 PM": 231, "7:20 PM": 232, "7:25 PM": 233, "7:30 PM": 234, "7:35 PM": 235, "7:40 PM": 236, "7:45 PM": 237, "7:50 PM": 238, "7:55 PM": 239, "8:00 PM": 240, "8:05 PM": 241, "8:10 PM": 242, "8:15 PM": 243, "8:20 PM": 244, "8:25 PM": 245, "8:30 PM": 246, "8:35 PM": 247, "8:40 PM": 248, "8:45 PM": 249, "8:50 PM": 250, "8:55 PM": 251, "9:00 PM": 252, "9:05 PM": 253, "9:10 PM": 254, "9:15 PM": 255, "9:20 PM": 256, "9:25 PM": 257, "9:30 PM": 258, "9:35 PM": 259, "9:40 PM": 260, "9:45 PM": 261, "9:50 PM": 262, "9:55 PM": 263, "10:00 PM": 264, "10:05 PM": 265, "10:10 PM": 266, "10:15 PM": 267, "10:20 PM": 268, "10:25 PM": 269, "10:30 PM": 270, "10:35 PM": 271, "10:40 PM": 272, "10:45 PM": 273, "10:50 PM": 274, "10:55 PM": 275, "11:00 PM": 276, "11:05 PM": 277, "11:10 PM": 278, "11:15 PM": 279, "11:20 PM": 280, "11:25 PM": 281, "11:30 PM": 282, "11:35 PM": 283, "11:40 PM": 284, "11:45 PM": 285, "11:50 PM": 286, "11:55 PM": 287 ]
    
    static let itst: [Int: String] = [0: "12:00 AM", 1: "12:05 AM", 2: "12:10 AM", 3: "12:15 AM", 4: "12:20 AM", 5: "12:25 AM", 6: "12:30 AM", 7: "12:35 AM", 8: "12:40 AM", 9: "12:45 AM", 10: "12:50 AM", 11: "12:55 AM", 12: "1:00 AM", 13: "1:05 AM", 14: "1:10 AM", 15: "1:15 AM", 16: "1:20 AM", 17: "1:25 AM", 18: "1:30 AM", 19: "1:35 AM", 20: "1:40 AM", 21: "1:45 AM", 22: "1:50 AM", 23: "1:55 AM", 24: "2:00 AM", 25: "2:05 AM", 26: "2:10 AM", 27: "2:15 AM", 28: "2:20 AM", 29: "2:25 AM", 30: "2:30 AM", 31: "2:35 AM", 32: "2:40 AM", 33: "2:45 AM", 34: "2:50 AM", 35: "2:55 AM", 36: "3:00 AM", 37: "3:05 AM", 38: "3:10 AM", 39: "3:15 AM", 40: "3:20 AM", 41: "3:25 AM", 42: "3:30 AM", 43: "3:35 AM", 44: "3:40 AM", 45: "3:45 AM", 46: "3:50 AM", 47: "3:55 AM", 48: "4:00 AM", 49: "4:05 AM", 50: "4:10 AM", 51: "4:15 AM", 52: "4:20 AM", 53: "4:25 AM", 54: "4:30 AM", 55: "4:35 AM", 56: "4:40 AM", 57: "4:45 AM", 58: "4:50 AM", 59: "4:55 AM", 60: "5:00 AM", 61: "5:05 AM", 62: "5:10 AM", 63: "5:15 AM", 64: "5:20 AM", 65: "5:25 AM", 66: "5:30 AM", 67: "5:35 AM", 68: "5:40 AM", 69: "5:45 AM", 70: "5:50 AM", 71: "5:55 AM", 72: "6:00 AM", 73: "6:05 AM", 74: "6:10 AM", 75: "6:15 AM", 76: "6:20 AM", 77: "6:25 AM", 78: "6:30 AM", 79: "6:35 AM", 80: "6:40 AM", 81: "6:45 AM", 82: "6:50 AM", 83: "6:55 AM", 84: "7:00 AM", 85: "7:05 AM", 86: "7:10 AM", 87: "7:15 AM", 88: "7:20 AM", 89: "7:25 AM", 90: "7:30 AM", 91: "7:35 AM", 92: "7:40 AM", 93: "7:45 AM", 94: "7:50 AM", 95: "7:55 AM", 96: "8:00 AM", 97: "8:05 AM", 98: "8:10 AM", 99: "8:15 AM", 100: "8:20 AM", 101: "8:25 AM", 102: "8:30 AM", 103: "8:35 AM", 104: "8:40 AM", 105: "8:45 AM", 106: "8:50 AM", 107: "8:55 AM", 108: "9:00 AM", 109: "9:05 AM", 110: "9:10 AM", 111: "9:15 AM", 112: "9:20 AM", 113: "9:25 AM", 114: "9:30 AM", 115: "9:35 AM", 116: "9:40 AM", 117: "9:45 AM", 118: "9:50 AM", 119: "9:55 AM", 120: "10:00 AM", 121: "10:05 AM", 122: "10:10 AM", 123: "10:15 AM", 124: "10:20 AM", 125: "10:25 AM", 126: "10:30 AM", 127: "10:35 AM", 128: "10:40 AM", 129: "10:45 AM", 130: "10:50 AM", 131: "10:55 AM", 132: "11:00 AM", 133: "11:05 AM", 134: "11:10 AM", 135: "11:15 AM", 136: "11:20 AM", 137: "11:25 AM", 138: "11:30 AM", 139: "11:35 AM", 140: "11:40 AM", 141: "11:45 AM", 142: "11:50 AM", 143: "11:55 AM", 144: "12:00 PM", 145: "12:05 PM", 146: "12:10 PM", 147: "12:15 PM", 148: "12:20 PM", 149: "12:25 PM", 150: "12:30 PM", 151: "12:35 PM", 152: "12:40 PM", 153: "12:45 PM", 154: "12:50 PM", 155: "12:55 PM", 156: "1:00 PM", 157: "1:05 PM", 158: "1:10 PM", 159: "1:15 PM", 160: "1:20 PM", 161: "1:25 PM", 162: "1:30 PM", 163: "1:35 PM", 164: "1:40 PM", 165: "1:45 PM", 166: "1:50 PM", 167: "1:55 PM", 168: "2:00 PM", 169: "2:05 PM", 170: "2:10 PM", 171: "2:15 PM", 172: "2:20 PM", 173: "2:25 PM", 174: "2:30 PM", 175: "2:35 PM", 176: "2:40 PM", 177: "2:45 PM", 178: "2:50 PM", 179: "2:55 PM", 180: "3:00 PM", 181: "3:05 PM", 182: "3:10 PM", 183: "3:15 PM", 184: "3:20 PM", 185: "3:25 PM", 186: "3:30 PM", 187: "3:35 PM", 188: "3:40 PM", 189: "3:45 PM", 190: "3:50 PM", 191: "3:55 PM", 192: "4:00 PM", 193: "4:05 PM", 194: "4:10 PM", 195: "4:15 PM", 196: "4:20 PM", 197: "4:25 PM", 198: "4:30 PM", 199: "4:35 PM", 200: "4:40 PM", 201: "4:45 PM", 202: "4:50 PM", 203: "4:55 PM", 204: "5:00 PM", 205: "5:05 PM", 206: "5:10 PM", 207: "5:15 PM", 208: "5:20 PM", 209: "5:25 PM", 210: "5:30 PM", 211: "5:35 PM", 212: "5:40 PM", 213: "5:45 PM", 214: "5:50 PM", 215: "5:55 PM", 216: "6:00 PM", 217: "6:05 PM", 218: "6:10 PM", 219: "6:15 PM", 220: "6:20 PM", 221: "6:25 PM", 222: "6:30 PM", 223: "6:35 PM", 224: "6:40 PM", 225: "6:45 PM", 226: "6:50 PM", 227: "6:55 PM", 228: "7:00 PM", 229: "7:05 PM", 230: "7:10 PM", 231: "7:15 PM", 232: "7:20 PM", 233: "7:25 PM", 234: "7:30 PM", 235: "7:35 PM", 236: "7:40 PM", 237: "7:45 PM", 238: "7:50 PM", 239: "7:55 PM", 240: "8:00 PM", 241: "8:05 PM", 242: "8:10 PM", 243: "8:15 PM", 244: "8:20 PM", 245: "8:25 PM", 246: "8:30 PM", 247: "8:35 PM", 248: "8:40 PM", 249: "8:45 PM", 250: "8:50 PM", 251: "8:55 PM", 252: "9:00 PM", 253: "9:05 PM", 254: "9:10 PM", 255: "9:15 PM", 256: "9:20 PM", 257: "9:25 PM", 258: "9:30 PM", 259: "9:35 PM", 260: "9:40 PM", 261: "9:45 PM", 262: "9:50 PM", 263: "9:55 PM", 264: "10:00 PM", 265: "10:05 PM", 266: "10:10 PM", 267: "10:15 PM", 268: "10:20 PM", 269: "10:25 PM", 270: "10:30 PM", 271: "10:35 PM", 272: "10:40 PM", 273: "10:45 PM", 274: "10:50 PM", 275: "10:55 PM", 276: "11:00 PM", 277: "11:05 PM", 278: "11:10 PM", 279: "11:15 PM", 280: "11:20 PM", 281: "11:25 PM", 282: "11:30 PM", 283: "11:35 PM", 284: "11:40 PM", 285: "11:45 PM", 286: "11:50 PM", 287: "11:55 PM"]
    
    static let heightGetterNum: [String: Int] = ["12:00 AM": 0, "12:05 AM": 1, "12:10 AM": 2, "12:15 AM": 3, "12:20 AM": 4, "12:25 AM": 5, "12:30 AM": 6, "12:35 AM": 7, "12:40 AM": 8, "12:45 AM": 9, "12:50 AM": 10, "12:55 AM": 11, "1:00 AM": 12, "1:05 AM": 13, "1:10 AM": 14, "1:15 AM": 15, "1:20 AM": 16, "1:25 AM": 17, "1:30 AM": 18, "1:35 AM": 19, "1:40 AM": 20, "1:45 AM": 21, "1:50 AM": 22, "1:55 AM": 23, "2:00 AM": 24, "2:05 AM": 25, "2:10 AM": 26, "2:15 AM": 27, "2:20 AM": 28, "2:25 AM": 29, "2:30 AM": 30, "2:35 AM": 31, "2:40 AM": 32, "2:45 AM": 33, "2:50 AM": 34, "2:55 AM": 35, "3:00 AM": 36, "3:05 AM": 37, "3:10 AM": 38, "3:15 AM": 39, "3:20 AM": 40, "3:25 AM": 41, "3:30 AM": 42, "3:35 AM": 43, "3:40 AM": 44, "3:45 AM": 45, "3:50 AM": 46, "3:55 AM": 47, "4:00 AM": 48, "4:05 AM": 49, "4:10 AM": 50, "4:15 AM": 51, "4:20 AM": 52, "4:25 AM": 53, "4:30 AM": 54, "4:35 AM": 55, "4:40 AM": 56, "4:45 AM": 57, "4:50 AM": 58, "4:55 AM": 59, "5:00 AM": 60, "5:05 AM": 61, "5:10 AM": 62, "5:15 AM": 63, "5:20 AM": 64, "5:25 AM": 65, "5:30 AM": 66, "5:35 AM": 67, "5:40 AM": 68, "5:45 AM": 69, "5:50 AM": 70, "5:55 AM": 71, "6:00 AM": 72, "6:05 AM": 73, "6:10 AM": 74, "6:15 AM": 75, "6:20 AM": 76, "6:25 AM": 77, "6:30 AM": 78, "6:35 AM": 79, "6:40 AM": 80, "6:45 AM": 81, "6:50 AM": 82, "6:55 AM": 83, "7:00 AM": 84, "7:05 AM": 85, "7:10 AM": 86, "7:15 AM": 87, "7:20 AM": 88, "7:25 AM": 89, "7:30 AM": 90, "7:35 AM": 91, "7:40 AM": 92, "7:45 AM": 93, "7:50 AM": 94, "7:55 AM": 95, "8:00 AM": 96, "8:05 AM": 97, "8:10 AM": 98, "8:15 AM": 99, "8:20 AM": 100, "8:25 AM": 101, "8:30 AM": 102, "8:35 AM": 103, "8:40 AM": 104, "8:45 AM": 105, "8:50 AM": 106, "8:55 AM": 107, "9:00 AM": 108, "9:05 AM": 109, "9:10 AM": 110, "9:15 AM": 111, "9:20 AM": 112, "9:25 AM": 113, "9:30 AM": 114, "9:35 AM": 115, "9:40 AM": 116, "9:45 AM": 117, "9:50 AM": 118, "9:55 AM": 119, "10:00 AM": 120, "10:05 AM": 121, "10:10 AM": 122, "10:15 AM": 123, "10:20 AM": 124, "10:25 AM": 125, "10:30 AM": 126, "10:35 AM": 127, "10:40 AM": 128, "10:45 AM": 129, "10:50 AM": 130, "10:55 AM": 131, "11:00 AM": 132, "11:05 AM": 133, "11:10 AM": 134, "11:15 AM": 135, "11:20 AM": 136, "11:25 AM": 137, "11:30 AM": 138, "11:35 AM": 139, "11:40 AM": 140, "11:45 AM": 141, "11:50 AM": 142, "11:55 AM": 143, "12:00 PM": 144, "12:05 PM": 145, "12:10 PM": 146, "12:15 PM": 147, "12:20 PM": 148, "12:25 PM": 149, "12:30 PM": 150, "12:35 PM": 151, "12:40 PM": 152, "12:45 PM": 153, "12:50 PM": 154, "12:55 PM": 155, "1:00 PM": 156, "1:05 PM": 157, "1:10 PM": 158, "1:15 PM": 159, "1:20 PM": 160, "1:25 PM": 161, "1:30 PM": 162, "1:35 PM": 163, "1:40 PM": 164, "1:45 PM": 165, "1:50 PM": 166, "1:55 PM": 167, "2:00 PM": 168, "2:05 PM": 169, "2:10 PM": 170, "2:15 PM": 171, "2:20 PM": 172, "2:25 PM": 173, "2:30 PM": 174, "2:35 PM": 175, "2:40 PM": 176, "2:45 PM": 177, "2:50 PM": 178, "2:55 PM": 179, "3:00 PM": 180, "3:05 PM": 181, "3:10 PM": 182, "3:15 PM": 183, "3:20 PM": 184, "3:25 PM": 185, "3:30 PM": 186, "3:35 PM": 187, "3:40 PM": 188, "3:45 PM": 189, "3:50 PM": 190, "3:55 PM": 191, "4:00 PM": 192, "4:05 PM": 193, "4:10 PM": 194, "4:15 PM": 195, "4:20 PM": 196, "4:25 PM": 197, "4:30 PM": 198, "4:35 PM": 199, "4:40 PM": 200, "4:45 PM": 201, "4:50 PM": 202, "4:55 PM": 203, "5:00 PM": 204, "5:05 PM": 205, "5:10 PM": 206, "5:15 PM": 207, "5:20 PM": 208, "5:25 PM": 209, "5:30 PM": 210, "5:35 PM": 211, "5:40 PM": 212, "5:45 PM": 213, "5:50 PM": 214, "5:55 PM": 215, "6:00 PM": 216, "6:05 PM": 217, "6:10 PM": 218, "6:15 PM": 219, "6:20 PM": 220, "6:25 PM": 221, "6:30 PM": 222, "6:35 PM": 223, "6:40 PM": 224, "6:45 PM": 225, "6:50 PM": 226, "6:55 PM": 227, "7:00 PM": 228, "7:05 PM": 229, "7:10 PM": 230, "7:15 PM": 231, "7:20 PM": 232, "7:25 PM": 233, "7:30 PM": 234, "7:35 PM": 235, "7:40 PM": 236, "7:45 PM": 237, "7:50 PM": 238, "7:55 PM": 239, "8:00 PM": 240, "8:05 PM": 241, "8:10 PM": 242, "8:15 PM": 243, "8:20 PM": 244, "8:25 PM": 245, "8:30 PM": 246, "8:35 PM": 247, "8:40 PM": 248, "8:45 PM": 249, "8:50 PM": 250, "8:55 PM": 251, "9:00 PM": 252, "9:05 PM": 253, "9:10 PM": 254, "9:15 PM": 255, "9:20 PM": 256, "9:25 PM": 257, "9:30 PM": 258, "9:35 PM": 259, "9:40 PM": 260, "9:45 PM": 261, "9:50 PM": 262, "9:55 PM": 263, "10:00 PM": 264, "10:05 PM": 265, "10:10 PM": 266, "10:15 PM": 267, "10:20 PM": 268, "10:25 PM": 269, "10:30 PM": 270, "10:35 PM": 271, "10:40 PM": 272, "10:45 PM": 273, "10:50 PM": 274, "10:55 PM": 275, "11:00 PM": 276, "11:05 PM": 277, "11:10 PM": 278, "11:15 PM": 279, "11:20 PM": 280, "11:25 PM": 281, "11:30 PM": 282, "11:35 PM": 283, "11:40 PM": 284, "11:45 PM": 285, "11:50 PM": 286, "11:55 PM": 287  ]
    
    

    func getTimeNum(startTime: String, endTime: String) -> Int {
        let startTimeNumber = Utilities.stit[startTime];
        let endTimeNumber = Utilities.stit[endTime];
        if let start = startTimeNumber, let end = endTimeNumber {
            return end - start;
        }
        return 0;
       }
    
    static let timeDurationStringToInt: [String: Int] = ["5 Minutes": 1, "10 Minutes": 2, "15 Minutes": 3, "20 Minutes": 4, "25 Minutes": 5, "30 Minutes": 6, "35 Minutes": 7, "40 Minutes": 8, "45 Minutes": 9, "50 Minutes": 10, "55 Minutes": 11, "1 Hour": 12]
    
    static let timeDurationIntToString: [Int: String] = [1: "5 Minutes", 2: "10 Minutes", 3: "15 Minutes", 4: "20 Minutes", 5: "25 Minutes", 6: "30 Minutes", 7: "35 Minutes", 8: "40 Minutes", 9: "45 Minutes", 10: "50 Minutes", 11: "55 Minutes", 12: "1 Hour", 13: "1 Hour 5 Minutes", 14: "1 Hour 10 Minutes", 15: "1 Hour 15 Minutes", 16: "1 Hour 20 Minutes", 17: "1 Hour 25 Minutes", 18: "1 Hour 30 Minutes", 19: "1 Hour 35 Minutes", 20 : "1 Hour 40 Minutes", 21: "1 Hour 45 Minutes", 22: "1 Hour 50 Minutes", 23: "1 Hour 55 Minutes", 24: "2 Hours"];
    
    
    func determineColumnHeight(dayStart: String, dayEnd: String) -> Double {
        var blockNum = 16;
        let correctNumber = Utilities.heightGetterNum[dayEnd]! - Utilities.heightGetterNum[dayStart]!
        let correctDouble = Double(correctNumber * blockNum);
        return correctDouble;
    }
}
