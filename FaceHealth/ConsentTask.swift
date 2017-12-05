//
//  ConsentTask.swift
//  SampleResearchKit
//
//  Created by Simon Ng on 3/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {
    
    let Document = ORKConsentDocument()
    Document.title = "Consent"
    
    let sectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .studySurvey
    ]
    
//    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
//        let consentSection = ORKConsentSection(type: contentSectionType)
//        consentSection.summary = "Complete the study"
//        consentSection.content = "This survey contains three questions."
//        return consentSection
//    }
    
    let consentSection1 = ORKConsentSection(type: .overview)
    consentSection1.summary = "FaceHealth is your pocket triage"
    consentSection1.content = "This app will use your photo data to give you a trend of your health overtime, and it will let you know if you are in any health risks."
    let consentSection2 = ORKConsentSection(type: .dataGathering)
    consentSection2.summary = "We will use your photo data to predict your health trend"
    consentSection2.content = "This app will collect photo data and survey data from you, and it will be secured and not shared."
    let consentSection3 = ORKConsentSection(type: .privacy)
    consentSection3.summary = "We will make sure your data is secure"
    consentSection3.content = "This app will use your photo data solely for the purpose of giving you the most convenient triage experience."
    let consentSection4 = ORKConsentSection(type: .dataUse)
    consentSection4.summary = "Data is money, we will put your interests first"
    consentSection4.content = "This app will use your photo and survey data responsibly, and will only be used for your interests."
    let consentSection5 = ORKConsentSection(type: .studySurvey)
    consentSection5.summary = "Sometimes we need more details to contextualize your situation"
    consentSection5.content = "This app will provide you a survey to gather more detailed results to better contextualize your situation."
    
    Document.sections = [consentSection1,consentSection2,consentSection3,consentSection4,consentSection5]
    Document.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "UserSignature"))
    
    var steps = [ORKStep]()
    
    //Visual Consent
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: Document)
    steps += [visualConsentStep]
    
    //Signature
    let signature = Document.signatures!.first! as ORKConsentSignature
    let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature, in: Document)
    reviewConsentStep.text = "Review the consent"
    reviewConsentStep.reasonForConsent = "Consent to join the Research Study."
    
    steps += [reviewConsentStep]
    
    //Completion
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Welcome"
    completionStep.text = "Thank you for joining this study."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
