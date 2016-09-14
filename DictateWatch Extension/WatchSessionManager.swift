//
//  WatchSessionManager.swift
//  Dictate
//
//  Created by Mike Derr on 6/30/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
//
//  WatchSessionManager.swift
//  WCApplicationContextDemo
//
//  Created by Natasha Murashev on 9/22/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(_ dataSource: DataSource)
}


class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    fileprivate let session: WCSession = WCSession.default()
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func addDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T>(_ delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        for (index, indexDelegate) in dataSourceChangedDelegates.enumerated() {
            if let indexDelegate = indexDelegate as? T , indexDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.dataSourceChangedDelegates.forEach { $0.dataSourceDidUpdate(DataSource(data: applicationContext as [String : AnyObject]))}
        }
        
    }
}
