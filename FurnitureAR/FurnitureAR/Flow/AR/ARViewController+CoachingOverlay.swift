import UIKit
import ARKit

// MARK: - ARCoachingOverlayViewDelegate
extension ARViewController: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        upperControlsView.isHidden = true
        addVirtualObjectButton.isHidden = true
        showCoachingOverlay()
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        upperControlsView.isHidden = false
        addVirtualObjectButton.isHidden = false
        hideCoachingOverlay()
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        restartExperience()
    }

    func setupCoachingOverlay() {
        customCoachingOverlayView.alpha = 0
        
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        setActivatesAutomatically()
        setGoal()
    }

    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }

    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}
