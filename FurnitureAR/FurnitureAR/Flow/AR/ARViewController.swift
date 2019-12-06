import ARKit
import SceneKit
import UIKit

class ARViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var sceneView: VirtualObjectARView!
    @IBOutlet weak var upperControlsView: UIView!
    @IBOutlet weak var customCoachingOverlayView: UIView!
    @IBOutlet weak var addVirtualObjectButton: UIButton!
    @IBOutlet weak var addButtonActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Interface
    
    var virtualObjectId: Int?
    
    // MARK: - UI Elements
    
    let coachingOverlay = ARCoachingOverlayView()
    var focusSquare = FocusSquare()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Set up coaching overlay.
        setupCoachingOverlay()

        // Set up scene content.
        sceneView.scene.rootNode.addChildNode(focusSquare)

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the `ARSession`.
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }

    // MARK: - Methods
    
    func setAddButtonImages() {
        addVirtualObjectButton.imageEdgeInsets = .zero
        addVirtualObjectButton.setImage(ImageProvider.add.image, for: .normal)
    }
    
    func setCloseButtonImages() {
        addVirtualObjectButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addVirtualObjectButton.setImage(ImageProvider.close.image, for: .normal)
    }
    
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
    
    // MARK: - Session management
    
    func restartExperience() {
        guard isRestartAvailable, !virtualObjectLoader.isLoading else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()
        virtualObjectLoader.removeAllVirtualObjects()

        resetTracking()
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.upperControlsView.isHidden = false
        }
    }
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        virtualObjectInteraction.selectedObject = nil
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
        setAddButtonImages()
    }

    // MARK: - Focus Square

    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || virtualObjectLoader.loadedObjects.hasElements {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            if !coachingOverlay.isActive {
                addVirtualObjectButton.isHidden = false
            }
            statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            if addVirtualObjectButton.currentImage != ImageProvider.close.image {
                addVirtualObjectButton.isHidden = true
            }
        }
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}