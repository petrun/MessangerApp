import Foundation

extension Date {
    func timeElapsed() -> String {
        let seconds = Date().timeIntervalSince(self)
        var elapsed = ""

        if seconds < 60 {
            elapsed = "Just now"
        } else if seconds < 3600 {
            let minutes = Int(seconds / 60)
            let minText = minutes > 1 ? "mins" : "min"

            elapsed = " \(minutes) \(minText)"
        } else if seconds < 24 * 3600 {
            let hours = Int(seconds / 3600)
            let hourText = hours > 1 ? "hours" : "hour"

            elapsed = " \(hours) \(hourText)"
        } else {
            elapsed = longDate()
        }

        return elapsed
    }

    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }

    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
