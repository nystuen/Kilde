import Foundation
import SwiftUI

struct FeedbackModel {
    var feedbackText: String
    var userEmail: String = ""
    var articleId: String? = nil
}


class FeedbackViewModel: ObservableObject {
    @Published var feedbackModel: FeedbackModel
    @Published var feedbackSumitted: Bool = false

    init() {
        self.feedbackModel = FeedbackModel(feedbackText: "")
    }

    func submitFeedback() {
        print("Feedback submitted:", feedbackModel)
        if let articleId = feedbackModel.articleId {
            print("Linked Article ID:", articleId)
        }
        DispatchQueue.main.async {
            self.feedbackSumitted = true
        }
    }
}
