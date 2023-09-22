//
//  TestModel.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 22/01/23.
//  Copyright © 2023 Gamelap Studios LLC. All rights reserved.
//

import Foundation

enum Test: CaseIterable {
    
    enum ScoreType: String, CaseIterable {
        case local = "local"
        case global = "global"
    }
    
    enum Level: String, CaseIterable  {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    
    enum Count: Int, CaseIterable  {
        case five = 5
        case ten = 10
        case fifteen = 15
//        case fifty = 50
        case eighty = 80
    }
    
    enum TType: String, CaseIterable  {
        case practice = "practice"
        case test = "test"
    }
    
    enum Category: String, CaseIterable  {
        case math = "math"
        case sequence = "sequence"
    }
    
    enum Key: String, CaseIterable {
        case DIFFICULTY_KEY = "Difficulty_Key"
        case QUESTNUM_KEY = "Question_Num_Key"
        case POT_KEY = "PoT_Key"
        case TEST_TYPE_KEY = "Test_Type_Key"
        case SETTINGS_SAVED_KEY = "SETTINGS_SAVED_KEY"
        
        var val : String {
            return self.rawValue
        }
    }
    
}
