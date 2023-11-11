//
//  File.swift
//  
//
//  Created by Justin on 9/4/23.
//

import Foundation

let dateSpaceTimeFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    return formatter
}()

let dateWithDashesFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

enum FieldType: Equatable, Hashable {
    case integer(nullable: Bool, expectedValue: Int?, expectedLength: Int?)
    case float(nullable: Bool)
    case string(nullable: Bool, expectedLength: Int?, startsWith: String?, contains: String?)
    case unknownString(nullable: Bool)
    case date(nullable: Bool)
    case dateTime
    case empty
}

extension FieldType {
    func validate(inputString input: String) -> ValidationResult {
        switch self {
        case .integer(let nullable, let expectedValue, let expectedLength):
            if input.isEmpty {
                return nullable ? .null : .invalid
            }else if let expectedValue {
                if let inputInt = Int(input) {
                    return inputInt == expectedValue ? .valid : .invalid
                }else{
                    return .invalid
                }
            }else if let expectedLength {
                if input.count == expectedLength {
                    return Int(input) != nil ? .valid : .invalid
                }else{
                    return .invalid
                }
            } else {
                return Int(input) != nil ? .valid : .invalid
            }
        case .float(let nullable):
            if input.isEmpty {
                return nullable ? .null : .invalid
            } else {
                return Float(input) != nil ? .valid : .invalid
            }
        case .string(let nullable, let expectedLength, let startsWith, let contains):
            if input.isEmpty {
                return nullable ? .null : .invalid
            }else if let expectedLength {
                if input.count == expectedLength {
                    if let startsWith {
                        return input.hasPrefix(startsWith) ? .valid : .invalid
                    } else {
                        return .valid
                    }
                } else {
                    return .invalid
                }
            }else if let startsWith {
                if let contains {
                    return input.hasPrefix(startsWith) && input.contains(contains) ? .valid : .invalid
                }else{
                    return input.hasPrefix(startsWith) ? .valid : .invalid
                }
            }else if let contains {
                if input.isEmpty {
                    return .null
                }else{
                    return input.contains(contains) ? .valid : .null
                }
            }else {
                print("failed to find expectedLength or startsWith")
                return .invalid
            }
        case .unknownString(let nullable):
            if input.isEmpty {
                return nullable ? .null : .invalid
            }else {
                return .unknownString
            }
        case .date:
            return dateWithDashesFormatter.date(from: input) != nil ? .valid : .invalid
        case .dateTime:
            return dateSpaceTimeFormatter.date(from: input) != nil ? .valid : .invalid
        case .empty:
            return input.isEmpty ? .valid : .invalid
        }
    }
}

extension FieldType {
    static let eventFieldNameToTypes: [String : FieldType] = [
        "Eventid": .integer(nullable: false, expectedValue: nil, expectedLength: nil), //Eventid
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: 4), //Seasoncode
        "Sectorcode": .string(nullable: false, expectedLength: 2, startsWith: nil, contains: nil), //Sectorcode
        "Eventname": .unknownString(nullable: true), //Eventname
        "Startdate": .date(nullable: false), //Startdate
        "Enddate": .date(nullable: false), //Enddate
        "Nationcodeplace": .string(nullable: false, expectedLength: 3, startsWith: nil, contains: nil), //Nationcodeplace
        "Orgnationcode": .string(nullable: false, expectedLength: 3, startsWith: nil, contains: nil), // Orgnationcode
        "Place": .unknownString(nullable: true), //Place
        "Published": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //Published
        "OrgaddressL1": .unknownString(nullable: true), //OrgaddressL1
        "OrgaddressL2": .unknownString(nullable: true), //OrgaddressL2
        "OrgaddressL3": .unknownString(nullable: true), //OrgaddressL3
        "OrgaddressL4": .unknownString(nullable: true), //OrgaddressL4
        "Orgtel": .unknownString(nullable: true), //Orgtel
        "Orgmobile": .unknownString(nullable: true), //Orgmobile
        "Orgfax": .unknownString(nullable: true), //Orgfax
        "OrgEmail": .string(nullable: false, expectedLength: nil, startsWith: nil, contains: "@"), //OrgEmail
        "OrgEntryEmail": .string(nullable: false, expectedLength: nil, startsWith: nil, contains: "@"),
        "Orgemailentries": .string(nullable: false, expectedLength: nil, startsWith: nil, contains: "@"), //Orgemailentries
        "Orgemailaccomodation": .string(nullable: false, expectedLength: nil, startsWith: nil, contains: "@"), //Orgemailaccomodation
        "Orgemailtransportation": .string(nullable: false, expectedLength: nil, startsWith: nil, contains: "@"), //Orgemailtransportation
        "OrgWebsite": .unknownString(nullable: true), //OrgWebsite
        "Socialmedia": .unknownString(nullable: true), //Socialmedia
        "Eventnotes": .unknownString(nullable: true), //Eventnotes
        "Languageused": .unknownString(nullable: true), //Languageused
        "Td1id": .unknownString(nullable: true), //Td1id
        "Td1name": .unknownString(nullable: true), //Td1name
        "Td1nation": .unknownString(nullable: true), //Td1nation
        "Td2id": .unknownString(nullable: true), //Td2id
        "Td2name": .unknownString(nullable: true), //Td2name
        "Td2nation": .unknownString(nullable: true), //Td2nation
        "Orgfee": .unknownString(nullable: true), //Orgfee
        "Bill": .unknownString(nullable: true), //Bill
        "Billdate": .unknownString(nullable: true), //Billdate
        "Selcat": .string(nullable: false, expectedLength: nil, startsWith: "-", contains: nil), //Selcat
        "Seldis": .string(nullable: false, expectedLength: nil, startsWith: "-", contains: nil), //Seldis
        "Seldisl": .unknownString(nullable: true), //Seldisl
        "Seldism": .unknownString(nullable: true), //Seldism
        "Dispdate": .unknownString(nullable: true), //Dispdate
        "Discomment": .unknownString(nullable: true), //Discomment
        "Version": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //Version,
        "Nationeventid": .unknownString(nullable: true), //Nationeventid
        "Proveventid": .unknownString(nullable: true), //Proveventid
        "Mssql7id": .unknownString(nullable: true), //Mssql7id
        "Results": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //Results
        "Pdf": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //Pdf
        "Topbanner": .unknownString(nullable: true), //Topbanner
        "Bottombanner": .unknownString(nullable: true), //Bottombanner
        "Toplogo": .unknownString(nullable: true), //Toplogo
        "Bottomlogo": .unknownString(nullable: true), //Bottomlogo
        "Gallery": .unknownString(nullable: true), //Gallery
        "Nextracedate": .unknownString(nullable: true), //Nextracedate
        "Lastracedate": .unknownString(nullable: true), //Lastracedate
        "TDletter": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //TDletter
        "Orgaddressid": .unknownString(nullable: true), //Orgaddressid
        "Tournament": .integer(nullable: false, expectedValue: nil, expectedLength: 1), //Tournament
        "Parenteventid": .integer(nullable: true, expectedValue: nil, expectedLength: 1), //Parenteventid
        "Placeid": .integer(nullable: true, expectedValue: nil, expectedLength: nil), //Placeid
        "Lastupdate": .dateTime //Lastupdate
    ]

    static let raceFieldNameToTypes: [String : FieldType] = [
        "Raceid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Eventid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: 4),
        "Racecodex": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Disciplineid": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Disciplinecode": .unknownString(nullable: true),
        "Catcode": .unknownString(nullable: true),
        "Catcode2": .unknownString(nullable: true),
        "Catcode3": .unknownString(nullable: true),
        "Catcode4": .unknownString(nullable: true),
        "Gender": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Racedate": .date(nullable: false),
        "Starteventdate": .date(nullable: false),
        "Description": .unknownString(nullable: true),
        "Place": .unknownString(nullable: true),
        "Nationcode": .string(nullable: false, expectedLength: 3, startsWith: nil, contains: nil),
        "Td1id": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Td1name": .unknownString(nullable: true),
        "Td1nation": .unknownString(nullable: true),
        "Td1code": .unknownString(nullable: true),
        "Td2id": .unknownString(nullable: true),
        "Td2name": .unknownString(nullable: true),
        "Td2nation": .unknownString(nullable: true),
        "Td2code": .unknownString(nullable: true),
        "Calstatuscode": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil), // could be an enum
        "Procstatuscode": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil), // could be an enum
        "Receiveddate": .empty,
        "Pursuit": .empty,
        "Masse": .empty,
        "Relay": .empty,
        "Distance": .empty,
        "Hill": .empty,
        "Style": .unknownString(nullable: true),
        "Qualif": .empty,
        "Finale": .unknownString(nullable: true),
        "Homol": .unknownString(nullable: true),
        "Webcomment": .unknownString(nullable: true),
        "Displaystatus": .unknownString(nullable: true),
        "Fisinterncomment": .unknownString(nullable: true),
        "Published": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Validforfispoints": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Usedfislist": .unknownString(nullable: true),
        "Tolist": .unknownString(nullable: true),
        "Discforlistcode": .empty,
        "Calculatedpenalty": .float(nullable: true),
        "Appliedpenalty": .float(nullable: true),
        "Appliedscala": .empty,
        "Penscafixed": .integer(nullable: true, expectedValue: 0, expectedLength: nil),
        "Version": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Nationraceid": .unknownString(nullable: true),
        "Provraceid": .empty,
        "Msql7evid": .empty,
        "Mssql7id": .empty,
        "Results": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Pdf": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Topbanner": .unknownString(nullable: true),
        "Bottombanner": .unknownString(nullable: true),
        "Toplogo": .unknownString(nullable: true),
        "Bottomlogo": .unknownString(nullable: true),
        "Gallery": .unknownString(nullable: true),
        "Indi": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Team": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Tabcount": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Columncount": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Level": .unknownString(nullable: true),
        "Hloc1": .unknownString(nullable: true),
        "Hloc2": .unknownString(nullable: true),
        "Hloc3": .unknownString(nullable: true),
        "Hcet1": .unknownString(nullable: true),
        "Hcet2": .unknownString(nullable: true),
        "Hcet3": .unknownString(nullable: true),
        "Live": .integer(nullable: true, expectedValue: nil, expectedLength: 1),
        "Livestatus": .unknownString(nullable: true),
        "Livestatus1": .unknownString(nullable: true),
        "Livestatus2": .unknownString(nullable: true),
        "Livestatus3": .unknownString(nullable: true),
        "Liveinfo": .unknownString(nullable: true),
        "Liveinfo1": .unknownString(nullable: true),
        "Liveinfo2": .unknownString(nullable: true),
        "Liveinfo3": .unknownString(nullable: true),
        "Passwd": .unknownString(nullable: true),
        "Timinglogo": .unknownString(nullable: true),
        "validdate": .date(nullable: true),
        "Validdate": .date(nullable: true),
        "Noepr": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "TDdoc": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Timingreport": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Special_cup_points": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Skip_wcsl": .integer(nullable: false, expectedValue: 0, expectedLength: nil),
        "Lastupdate": .dateTime,
        "Gender_2021": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
    ]
    static let raceResultFieldNameToTypes: [String : FieldType] = [
        "Recid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Raceid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Competitorid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Status": .unknownString(nullable: false),
        "Reason": .empty,
        "Status2": .empty,
        "Position": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Bib": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Fiscode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Competitorname": .unknownString(nullable: false),
        "Nationcode": .unknownString(nullable: false),
        "Level": .integer(nullable: true, expectedValue: nil, expectedLength: 1),
        "Heat": .empty,
        "Timer1": .unknownString(nullable: true),
        "Timer2": .unknownString(nullable: true),
        "Timer3": .unknownString(nullable: true),
        "Timetot": .unknownString(nullable: true),
        "Valid": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Racepoints": .float(nullable: true),
        "Cuppoints": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Version": .empty,
        "Timer1int": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Timer2int": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Timer3int": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Timetotint": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Racepointsreceived": .float(nullable: true),
        "Listfispoints": .float(nullable: true),
        "Ptsmax": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Lastupdate": .dateTime
    ]
    static let athleteFieldNameToTypes: [String : FieldType] = [
        "Competitorid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Sectorcode": .string(nullable: false, expectedLength: nil, startsWith: "AL", contains: nil),
        "Fiscode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Lastname": .unknownString(nullable: false),
        "Firstname": .unknownString(nullable: false),
        "Gender": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Birthdate": .date(nullable: true),
        "Nationcode": .unknownString(nullable: false),
        "Nationalcode": .unknownString(nullable: true),
        "Skiclub": .unknownString(nullable: true),
        "Association": .unknownString(nullable: true),
        "Status": .string(nullable: true, expectedLength: 1, startsWith: nil, contains: nil),
        "Status_old": .string(nullable: true, expectedLength: 1, startsWith: nil, contains: nil),
        "Statusnextlist": .unknownString(nullable: true),
        "Gender_2021": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
    ]
    static let pointsFieldNameToTypes: [String : FieldType] = [
        "Recid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Competitorid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Disciplinecode": .string(nullable: true, expectedLength: 2, startsWith: nil, contains: nil),
        "Basepoints": .float(nullable: true), // only in base lists?
        "Fispoints": .float(nullable: true),
        "Position": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Penalty": .string(nullable: true, expectedLength: 1, startsWith: "*", contains: nil),
        "Active": .empty,
        "Avenumresults": .empty,
        "Fixedbyfis": .string(nullable: true, expectedLength: 1, startsWith: "0", contains: nil),
        "Raceid1": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Raceid2": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Raceid3": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Version": .empty,
        "Pointspreviouslist": .empty,
        "pourcentpreviouslist": .string(nullable: false, expectedLength: 1, startsWith: "0", contains: nil),
        "Countlistsamestatus": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "pourcent": .integer(nullable: true, expectedValue: 0, expectedLength: nil),
        "Realpoints": .float(nullable: true),
        "blessevalide": .integer(nullable: false, expectedValue: 1, expectedLength: nil),
        "Youthpoints": .unknownString(nullable: true),
        "Lastupdate": .dateTime,
    ]
    static let catFieldNameToTypes: [String : FieldType] = [
        "Recid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Catcode": .unknownString(nullable: false),
        "Gender": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Minfispoints": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Maxfispoints": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Version": .integer(nullable: true, expectedValue: 0, expectedLength: nil),
        "Lastupdate": .dateTime,
    ]
    static let hdrFieldNameToTypes: [String : FieldType] = [
        "Recid": .integer(nullable: false, expectedValue: nil, expectedLength: nil), // only for base lists
        "Listalid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listnumber": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listname": .unknownString(nullable: false),
        "Speciallist": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Printdeadline": .unknownString(nullable: true),
        "Calculationdate": .date(nullable: false),
        "Startracedate": .date(nullable: false),
        "Endracedate": .date(nullable: false),
        "Validfrom": .date(nullable: false),
        "Validto": .date(nullable: false),
        "Published": .integer(nullable: false, expectedValue: nil, expectedLength: 1),
        "Version": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Lastupdate": .dateTime,
    ]
    static let disFieldNameToTypes: [String : FieldType] = [
        "Recid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Listid": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Seasoncode": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Disciplinecode": .unknownString(nullable: false),
        "Gender": .string(nullable: false, expectedLength: 1, startsWith: nil, contains: nil),
        "Xvalue": .empty,
        "Yvalue": .empty,
        "Zvalue": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Minpenalty": .unknownString(nullable: true),
        "Maxpenalty": .unknownString(nullable: true),
        "Fvalue": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Maxpoints": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Injuryminpen": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Injurymaxpen": .integer(nullable: true, expectedValue: nil, expectedLength: nil),
        "Injurypercentage": .float(nullable: true),
        "Version": .integer(nullable: true, expectedValue: nil, expectedLength: 1),
        "Adder0": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder1": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder2": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder3": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder4": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder5": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Adder6": .integer(nullable: false, expectedValue: nil, expectedLength: nil),
        "Lastupdate": .dateTime
    ]
}

enum ValidationResult {
    case valid
    case null
    case unknownString
    case invalid
}
