import UIKit
import ARKit

// MARK: Coaching overlay configuring
extension ARViewController {
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

// MARK: - ARCoachingOverlay delegate
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
}


// MARK: - Coaching overlay methods
extension ARViewController {
    func showCoachingOverlay() {
        customCoachingOverlayView.isHidden = false
        UIView.animate(withDuration: 0.24, animations: {
            self.customCoachingOverlayView.alpha = 0.5
        })
    }
    
    func hideCoachingOverlay() {
        UIView.animate(withDuration: 0.17, animations: {
            self.customCoachingOverlayView.alpha = 0
        }) { _ in
            self.customCoachingOverlayView.isHidden = true
        }
    }
}
