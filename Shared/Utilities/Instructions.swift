//
//  ExpandRoutineFromShorthand.swift
//  breathe-swiftui
//

import Foundation

class RoutineTupleClass {
    var item = [(String, Int)]()
}


//
//  Routines can be defined in a shorthand.
//  i:2,e:2,r:2 creates a routine of inhale 2s, exhale 2s, repeat 2 times.
//  This converts shorthand to an array of the full routine: [("i", 2), ("e", 2), ("i", 2), ("e", 2)]
//
//  Note: If there are multiple repeats, each repeats only the segment starting from the prior repeat.
//

func expandRoutineShorthand(selectedRoutineInstruction: String) -> [(String, Int)]{
    
    let loud = true
    
    if loud { print("expanding routine \(selectedRoutineInstruction)") }
    
    var currentStepCount = 1
    var currentStepNumber = 0
    var currentStepInstruction = ""
    
    var isRepeating = false
    var hasRepeated = false
    var repeatFromIndex = 0
    var repeatToIndex = 0
    var repeatsRemaining = 0
    
    let shorthandRoutineContainer = RoutineTupleClass()
    let expandedRoutineContainer = RoutineTupleClass()
    
    let shorthandRoutineArray = selectedRoutineInstruction.components(separatedBy:CharacterSet(charactersIn: ":,"))
    
    /// separate even to odd
    let instructionStringArray = shorthandRoutineArray.enumerated().compactMap { $0 % 2 == 0 ? $1 : nil }
    let valuesStringArray = shorthandRoutineArray.enumerated().compactMap { $0 % 2 != 0 ? $1 : nil }
    
    /// convert values string array to int
    let valuesIntArray = valuesStringArray.map { Int($0)!}
    
    /// init array of tuples
    var combinedShorthandRoutineArray = [(String, Int)]()
    
    /// combine both arrays into the shorthand array
    for (index, _) in instructionStringArray.enumerated() {
        combinedShorthandRoutineArray.append((instructionStringArray[index], valuesIntArray[index]))
    }
    
    if loud { print("shorthand expand complete, routine = \(combinedShorthandRoutineArray)") }
    
    /// now, we expand the shorthand array to an expanded routine. this removes the repeat steps from the array. i:4,r:4 -> i:4,i:4,i:4,i:4
    shorthandRoutineContainer.item = combinedShorthandRoutineArray
    
    if loud { print("shorthand as tuple array = \(shorthandRoutineContainer.item)") }
    
    var expandedRoutine = [(String, Int)]()
    
    while currentStepNumber < shorthandRoutineContainer.item.count{
        let currentStep = shorthandRoutineContainer.item[currentStepNumber]
        currentStepInstruction = currentStep.0 // "exhale"
        currentStepCount = currentStep.1 // 5
        
        switch currentStepInstruction {
        case "i","e","p":
            expandedRoutine.append((currentStepInstruction, currentStepCount))
            currentStepNumber += 1
            if loud { print("added \(currentStepInstruction), \(currentStepCount) ") }
        case "r":
            if currentStepCount == 0{
                repeatFromIndex = currentStepNumber + 1
                currentStepNumber += 1
            }else{
                if !isRepeating{
                    repeatsRemaining = currentStepCount - 1
                    repeatToIndex = currentStepNumber
                    if hasRepeated == true{
                        repeatFromIndex = repeatToIndex + 1
                    }
                }
                if repeatsRemaining > 0{
                    isRepeating = true
                    currentStepNumber = repeatFromIndex
                    repeatsRemaining -= 1
                } else{
                    isRepeating = false
                    hasRepeated = true
                    if hasRepeated == true{
                        repeatFromIndex = repeatToIndex + 1
                    }
                }
            }
        default:
            break
        }
    }
    
    expandedRoutineContainer.item = expandedRoutine
    
    if loud { print("expanding complete, routine = \(expandedRoutineContainer.item)") }
    
    return expandedRoutineContainer.item
    
}

