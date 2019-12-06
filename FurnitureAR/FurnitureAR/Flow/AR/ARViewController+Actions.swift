import UIKit
import SceneKit

// MARK: - IBActions
extension ARViewController {
    /// Attaching selected virtual object to the reality
    @IBAction func addVirtualObject(_ sender: UIButton) {
        guard virtualObjectLoader.loadedObjects.isEmpty else {
            virtualObjectLoader.removeAllVirtualObjects()
            setAddButtonImages()
            return
        }
        guard let objectId = virtualObjectId,
            let selectedVirtualObject = VirtualObject.byId(objectId) else {
                statusViewController.showMessage("Не виявлено ідентифікаційного номера")
                return
        }
        updateObjectAvailability()
        loadVirtualObject(selectedVirtualObject)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ARViewController: UIGestureRecognizerDelegate {
    
    /// Determines if the tap gesture for presenting the `VirtualObjectSelectionViewController` should be used.
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return virtualObjectLoader.loadedObjects.isEmpty
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
