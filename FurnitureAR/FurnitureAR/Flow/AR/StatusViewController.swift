import Foundation
import ARKit

/**
 Displayed at the top of the main interface of the app that allows users to see
 the status of the AR experience, as well as the ability to control restarting
 the experience altogether.
*/
final class StatusViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var messagePanel: UIVisualEffectView! {
        didSet {
            messagePanel.layer.cornerRadius = 8
        }
    }
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var restartExperienceButton: UIButton!

    // MARK: - Properties
    
    /// Trigerred when the "Restart Experience" button is tapped.
    var restartExperienceHandler: () -> Void = {}
    
    /// Seconds before the timer message should fade out. Adjust if the app needs longer transient messages.
    private let displayDuration: TimeInterval = 6
    
    // Timer for hiding messages.
    private var messageHideTimer: Timer?
    
    private var timers: [MessageType: Timer] = [:]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("StatusViewController deinited")
    }
    
    // MARK: - Message Handling
    
    func showMessage(_ text: String, autoHide: Bool = true) {
        // Cancel any previous hide timer.
        messageHideTimer?.invalidate()

        messageLabel.text = text

        // Make sure status is showing.
        setMessageHidden(false, animated: true)

        if autoHide {
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.setMessageHidden(true, animated: true)
            })
        }
    }
    
    func scheduleMessage(_ text: String, inSeconds seconds: TimeInterval, messageType: MessageType) {
        cancelScheduledMessage(for: messageType)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] timer in
            self?.showMessage(text)
            timer.invalidate()
        })

        timers[messageType] = timer
    }
    
    func cancelScheduledMessage(for messageType: MessageType) {
        timers[messageType]?.invalidate()
        timers[messageType] = nil
    }

    func cancelAllScheduledMessages() {
        for messageType in MessageType.all {
            cancelScheduledMessage(for: messageType)
        }
    }
    
    // MARK: - ARKit
    
    func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
        showMessage(trackingState.presentationString, autoHide: autoHide)
    }
    
    func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
        cancelScheduledMessage(for: .trackingStateEscalation)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] _ in
            self?.cancelScheduledMessage(for: .trackingStateEscalation)

            var message = trackingState.presentationString
            if let recommendation = trackingState.recommendation {
                message.append(": \(recommendation)")
            }

            self?.showMessage(message, autoHide: false)
        })

        timers[.trackingStateEscalation] = timer
    }
    
    // MARK: - IBActions
    
    @IBAction private func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }
    
    // MARK: - Panel Visibility
    
    private func setMessageHidden(_ hide: Bool, animated: Bool) {
        // The panel starts out hidden, so show it before animating opacity.
        messagePanel.isHidden = false
        
        guard animated else {
            messagePanel.alpha = hide ? 0 : 1
            return
        }

        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
            self.messagePanel.alpha = hide ? 0 : 1
        }, completion: nil)
    }
}

// MARK: - Types
extension StatusViewController {
     enum MessageType {
         case trackingStateEscalation
         case planeEstimation
         case contentPlacement
         case focusSquare

         static var all: [MessageType] = [
             .trackingStateEscalation,
             .planeEstimation,
             .contentPlacement,
             .focusSquare
         ]
     }
}

// MARK: - Messages
extension ARCamera.TrackingState {
    var presentationString: String {
        switch self {
        case .notAvailable:
            return "Відслідковування недоступне"
        case .normal:
            return "Відслідковування в нормальному режимі"
        case .limited(.excessiveMotion):
            return "Відслідковування обмежене"
        case .limited(.insufficientFeatures):
            return "Відслідковування обмежене\nМало деталей"
        case .limited(.initializing):
            return "Ініціалізація"
        case .limited(.relocalizing):
            return "Відновлення після переревання"
        @unknown default:
            return "Невизначений стан відслідковування"
        }
    }

    var recommendation: String? {
        switch self {
        case .limited(.excessiveMotion):
            return "Спробуйте сповільнити ваші рухи, щоб перезапустити сесію"
        case .limited(.insufficientFeatures):
            return "Спробуйте фокусуватися на плоскій поверхні, або перезапустіть сесію"
        case .limited(.relocalizing):
            return "Поверніться на поверхню з якої ви перемістилися, або перезапустіть сесію"
        default:
            return nil
        }
    }
}
