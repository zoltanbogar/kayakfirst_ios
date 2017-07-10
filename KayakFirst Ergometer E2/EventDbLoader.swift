//
//  EventDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class EventDbLoader: BaseDbLoader<Event> {
    
    //MARK: constants
    static let tableName = "event_table"
    
    //MARK: init
    static let sharedInstance = EventDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let idKey = "id"
    }
    
    //MARK: columns
    let id = Expression<String>(PropertyKey.idKey)
    
    override func getTableName() -> String {
        return EventDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(userId)
            t.column(sessionId)
            t.column(timestamp)
            t.column(name)
            t.column(planType)
            t.column(planId)
        })
    }
    
    //TODO - refactor: event does not heave name
    //MARK: insert
    override func addData(data: Event?) {
        if let event = data {
            let insert = table!.insert(self.id <- event.eventId, self.userId <- event.userId, self.sessionId <- event.sessionId, self.timestamp <- event.timestamp, self.name <- "", self.planType <- event.planType.rawValue, self.planId <- event.planId)
            
            let rowId = try? db!.run(insert)
        }
    }
    
    //MARK: update
    override func updateData(data: Event) {
        //nothing here
    }
    
    //MARK: query
    override func queryData(predicate: Expression<Bool>?) -> [Event]? {
        var eventList: [Event]?
        
        do {
            let dbList = try db!.prepare(table!.filter(predicate!))
            
            eventList = [Event]()
            
            for eventDb in dbList {
                let event = Event(
                    eventId: eventDb[self.id],
                    userId: eventDb[self.userId],
                    sessionId: eventDb[self.sessionId],
                    timestamp: eventDb[self.timestamp],
                    name: eventDb[self.name] ?? "",
                    planType: PlanType(rawValue: eventDb[self.planType])!,
                    planId: eventDb[self.planId])
                
                eventList!.append(event)
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return eventList
    }
    
    func getEventDays() -> [Double] {
        var eventDays = [Double]()
        
        do {
            let query = table?.select(self.timestamp).order(self.timestamp)
            
            let dbList = try db!.prepare(query!)
            
            for days in dbList {
                let midnightTime = DateFormatHelper.getZeroHour(timeStamp: days[self.timestamp])
                eventDays.append(midnightTime)
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return eventDays
    }
    
    func getEventsByPlanId(planId: String) -> [Event]? {
        var events = [Event]()
        
        do {
            let query = table?.filter(self.planId == planId)
            
            let dbList = try db!.prepare(query!)
            
            for eventDb in dbList {
                let event = Event(
                    eventId: eventDb[self.id],
                    userId: eventDb[self.userId],
                    sessionId: eventDb[self.sessionId],
                    timestamp: eventDb[self.timestamp],
                    name: eventDb[self.name] ?? "",
                    planType: PlanType(rawValue: eventDb[self.planType])!,
                    planId: eventDb[self.planId])
                
                    events.append(event)
            }
            
        } catch {
            log(databaseLogTag, error)
        }
        
        return events
    }
    
    func getEventBetweenTimestampPredicate(timestampFrom: Double, timestampTo: Double) -> Expression<Bool> {
        return self.timestamp > timestampFrom && self.timestamp <= timestampTo
    }
    
    func getIdPredicate(eventId: String?) -> Expression<Bool>? {
        if let eventIdValue = eventId {
            return self.id == eventId!
        }
        return nil
    }
    
    //MARK: delete
    override func deleteData(predicate: Expression<Bool>?) -> Int {
        var deletedRows = 0
        
        let deleteData = table!.filter(predicate!)
        
        do {
            deletedRows = try db!.run(deleteData.delete())
        } catch {
            log(databaseLogTag, error)
        }
        return deletedRows
    }
}
