//
//  ScoreModel.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 23/01/23.
//  Copyright © 2023 Gamelap Studios LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ScoreModel {
    
    enum Keys: String {
        case date = "date"
        case score = "score"
        case difficulty = "difficulty"
        case testType = "test_type"
        case totalQuestions = "total_questions"
        case time = "time"
        
        var val: String {
            return self.rawValue
        }
    }
    
    var date: String = Date().description
    var score: Int = 0
    var difficulty: String = ""
    var testType: String = ""
    var totalQuestions: Int = 0
    var time: String = ""
    
    lazy var dict: [String: Any] =
    [ Keys.date.val : date,
      Keys.score.val: score,
      Keys.difficulty.val : difficulty,
      Keys.testType.val : testType,
      Keys.totalQuestions.val : totalQuestions,
      Keys.time.val : time ]
    
    init(dict: [String: Any]) {
        self.date = dict[Keys.date.val] as? String ?? ""
        self.score = dict[Keys.score.val] as? Int ?? 0
        self.difficulty = dict[Keys.difficulty.val] as? String ?? ""
        self.testType = dict[Keys.testType.val] as? String ?? ""
        self.totalQuestions = dict[Keys.totalQuestions.val] as? Int ?? 0
        self.time = dict[Keys.time.val] as? String ?? ""
    }
        
    init(date: String = Date().description, score: Int, difficulty: String, testType: String, totalQuestions: Int, time: String) {
        self.date = date
        self.score = score
        self.difficulty = difficulty
        self.testType = testType
        self.totalQuestions = totalQuestions
        self.time = time
    }
}

