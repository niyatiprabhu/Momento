//
//  healthData.swift
//  Momento
//
//  Created by Shadin Hussein on 4/3/23.
//

import Foundation
import HealthKit


class HealthKitManager {
        
        static let shared = HealthKitManager()

        private let healthStore = HKHealthStore()
        private var isAuthorized: Bool = false

        private init() {}

        func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
            guard HKHealthStore.isHealthDataAvailable() else {
                completion(false, nil)
                return
            }

            let stepsCount = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!])

            healthStore.requestAuthorization(toShare: nil, read: stepsCount) { (success, error) in
                if success {
                    self.isAuthorized = true
                }
                completion(success, error)
            }
        }

        // get step count for today so far
        func getStepsCount(completion: @escaping (Double?, Error?) -> Void) {
            guard isAuthorized else {
                completion(nil, nil) // Handle unauthorized access
                return
            }

            let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let startDate = Calendar.current.startOfDay(for: Date())
            let endDate = Date()

            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
                guard let result = result, let sum = result.sumQuantity() else {
                    // Handle error here
                    completion(nil, error)
                    return
                }

                let steps = sum.doubleValue(for: HKUnit.count())
                completion(steps, nil)
            }

            healthStore.execute(query)
        }
    
}
