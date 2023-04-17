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

        func getStepsCount(completion: @escaping (Double?, Error?) -> Void) {
            guard isAuthorized else {
                completion(nil, nil) // Handle unauthorized access
                return
            }

            let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let query = HKStatisticsQuery(quantityType: stepsCount, quantitySamplePredicate: nil, options: .cumulativeSum) { (_, result, error) in
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }

                let steps = sum.doubleValue(for: HKUnit.count())
                completion(steps, nil)
            }

            healthStore.execute(query)
        }

        // Other HealthKit methods can be added here
    
}
