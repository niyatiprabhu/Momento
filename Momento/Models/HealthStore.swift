//
//  healthData.swift
//  Momento
//
//  Created by Shadin Hussein on 4/3/23.
//

import Foundation
import HealthKit


class HealthStore{
    
    var healthStore: HKHealthStore?
    
    init() {
        
        //access HealthStore only if given access to data
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else {return completion(false)}
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in completion(success)}
    }
    
}
