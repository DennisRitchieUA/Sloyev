//
//  UserProfile+CoreDataProperties.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/7/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var gender: String?
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var growth: NSNumber?
    @NSManaged public var weight: NSNumber?
    @NSManaged public var avatar: URL?

}
