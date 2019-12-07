import UIKit
import ARKit

final class VirtualObjectInteraction: NSObject, UIGestureRecognizerDelegate {
    
    /// Developer setting to translate assuming the detected plane extends infinitely.
    let translateAssumingInfinitePlane = true
    
    /// The scene view to hit test against when moving virtual content.
    let sceneView: VirtualObjectARView
    
    /// A reference to the view controller.
    let viewController: ARViewController
    
    /**
     The object that has been most recently intereacted with.
     The `selectedObject` can be moved at any time with the tap gesture.
     */
    var selectedObject: VirtualObject?
    
    /// The object that is tracked for use by the pan and rotation gestures.
    var trackedObject: VirtualObject? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    
    /// The tracked screen position used to update the `trackedObject`'s position.
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: VirtualObjectARView, viewController: ARViewController) {
        self.sceneView = sceneView
        self.viewController = viewController
        super.init()
        
        createPanGestureRecognizer(sceneView)

        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleObject(gesture:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    func createPanGestureRecognizer(_ sceneView: VirtualObjectARView) {
        let panGesture = ThresholdPanGesture(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Actions
    
    @objc
    func didPan(_ gesture: ThresholdPanGesture) {
        switch gesture.state {
        case .began:
            // Check for an object at the touch location.
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
        case .changed where gesture.isThresholdExceeded:
            guard let object = trackedObject else { return }
            // Move an object if the displacment threshold has been met.
            translate(object, basedOn: updatedTrackingPosition(for: object, from: gesture))

            gesture.setTranslation(.zero, in: sceneView)
        case .changed:
            // Ignore the pan gesture until the displacment threshold is exceeded.
            break
        case .ended:
            // Update the object's position when the user stops panning.
            guard let object = trackedObject else { break }
            setDown(object, basedOn: updatedTrackingPosition(for: object, from: gesture))

            fallthrough
        default:
            // Reset the current position tracking.
            currentTrackingPosition = nil
            trackedObject = nil
        }
    }

    func updatedTrackingPosition(for object: VirtualObject, from gesture: UIPanGestureRecognizer) -> CGPoint {
        let translation = gesture.translation(in: sceneView)

        let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(object.position))
        let updatedPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
        currentTrackingPosition = updatedPosition

        return updatedPosition
    }

    /**
     For looking down on the object (99% of all use cases), you subtract the angle.
     To make rotation also work correctly when looking from below the object one would have to
     flip the sign of the angle depending on whether the object is above or below the camera.
    */
    @objc
    func didRotate(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
        case .changed:
            trackedObject?.objectRotation -= Float(gesture.rotation)
            gesture.rotation = 0
        default:
            trackedObject = nil
        }
    }
    
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
        case .changed:
            guard let trackedObject = trackedObject else { return }
           
            let pinchScaleX: CGFloat = gesture.scale * CGFloat((trackedObject.objectScale.x))
            let pinchScaleY: CGFloat = gesture.scale * CGFloat((trackedObject.objectScale.y))
            let pinchScaleZ: CGFloat = gesture.scale * CGFloat((trackedObject.objectScale.z))
            trackedObject.objectScale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
            
            gesture.scale = 1
        default:
            trackedObject = nil
        }
    }
    
    /// Handles the interaction when the user taps the screen.
    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        if let tappedObject = sceneView.virtualObject(at: touchLocation) {
            // If an object exists at the tap location, select it.
            selectedObject = tappedObject
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    /** A helper method to return the first object that is found under the provided `gesture`s touch locations.
     Performs hit tests using the touch locations provided by gesture recognizers. By hit testing against the bounding
     boxes of the virtual objects, this function makes it more likely that a user touch will affect the object even if the
     touch location isn't on a point where the object has visible content. By performing multiple hit tests for multitouch
     gestures, the method makes it more likely that the user touch affects the intended object.
    */
    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> VirtualObject? {
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)

            // Look for an object directly under the `touchLocation`.
            if let object = sceneView.virtualObject(at: touchLocation) {
                return object
            }
        }

        // As a last resort look for an object under the center of the touches.
        if let center = gesture.center(in: view) {
            return sceneView.virtualObject(at: center)
        }

        return nil
    }
    
    // MARK: - Update object position
    
    func translate(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()

        // Update the object by using a one-time position request.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment) {
            viewController.createRaycastAndUpdate3DPosition(of: object, from: query)
        }
    }
    
    func setDown(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()

        // Prepare to update the object's anchor to the current location.
        object.shouldUpdateAnchor = true

        // Attempt to create a new tracked raycast from the current location.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment),
            let raycast = viewController.createTrackedRaycastAndSet3DPosition(of: object, from: query) {
            object.raycast = raycast
        } else {
            // If the tracked raycast did not succeed, simply update the anchor to the object's current position.
            object.shouldUpdateAnchor = false
            viewController.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: object)
            }
        }
    }
}
