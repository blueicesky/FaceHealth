//
//  SurveyTask.swift
//  SampleResearchKit
//
//  Created by Simon Ng on 3/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Introduction
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Stroke Risk Survey"
    instructionStep.text = "Answer three questions to help us better assess your situation."
    steps += [instructionStep]
    
    let answerFormat = ORKBooleanAnswerFormat(yesString: "Yes", noString: "No")
    let yesQuestionStepTitle = "Are you experiencing any headaches?"
    let yesQuestionStep = ORKQuestionStep(identifier: "YesStep", title: yesQuestionStepTitle, answer: answerFormat)
    steps += [yesQuestionStep]
    
    let answerFormat2 = ORKBooleanAnswerFormat(yesString: "Yes", noString: "No")
    let yesQuestionStepTitle2 = "Are you able to smile properly?"
    let yesQuestionStep2 = ORKQuestionStep(identifier: "SmileStep", title: yesQuestionStepTitle2, answer: answerFormat2)
    steps += [yesQuestionStep2]
    
    //Numeric Input Question
    let ageQuestion = "How old are you?"
    let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
    ageAnswer.minimum = 7
    ageAnswer.maximum = 100
    let ageQuestionStep = ORKQuestionStep(identifier: "AgeStep", title: ageQuestion, answer: ageAnswer)
    steps += [ageQuestionStep]
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
