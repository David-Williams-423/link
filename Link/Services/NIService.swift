//
//  NIService.swift
//  Link
//
//  Created by AlecNipp on 10/28/23.
//

import Foundation
import MultipeerConnectivity
import NearbyInteraction
import Observation

@Observable
class NIService: NSObject, NISessionDelegate, ObservableObject {
    let nearbyDistanceThreshold: Float = 0.3

    enum DistanceDirectionState {
        case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
    }
    
    var inSession: Bool {
        connectedPeer != nil
    }


    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    var currentDistanceDirectionState: DistanceDirectionState = .unknown
    var mpc: MPCSession?
    var connectedPeer: MCPeerID?
    var sharedTokenWithPeer = false
    var peerDisplayName: String?
   
    // Textual description for the status of the service. Should be improved later.
    var informationLabel = ""
    func updateInformationLabel(description: String) {
        informationLabel = description
    }
    var monkeyLabel = ""
    var rotationAmount: Float?
    var distanceAway: Float?
    var feetAway: Float? {
        if let distanceAway = distanceAway {
            return distanceAway * 3.28084
        }
        return nil
    }
    
    var feetString: String? {
        guard let feet = feetAway else { return nil }
        
        return feet < 10 ? String(format: "%.1f", feet) : String(format: "%.0f", feet)
    }
    
    func scaleForCircleBasedOnDistance() -> CGFloat {
            guard let feetAway = feetAway else { return 1.0 }
            let scale = 0.7 + 0.3 * CGFloat(feetAway / 0.5)
            return min(max(scale, 0.7), 1.0) // Clamp the value between 0.7 and 1.0
        }

    
    func startup() {
        // Create the NISession.
        session = NISession()

        // Set the delegate.
        session?.delegate = self

        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false

        // If `connectedPeer` exists, share the discovery token, if needed.
        if connectedPeer != nil && mpc != nil {
            if let myToken = session?.discoveryToken {
//                updateInformationLabel(description: "Initializing ...")
                    updateInformationLabel(description: "Initializing Connection to Peer")
                if !sharedTokenWithPeer {
                    shareMyDiscoveryToken(token: myToken)
                }
                guard let peerToken = peerDiscoveryToken else {
                    return
                }
                let config = NINearbyPeerConfiguration(peerToken: peerToken)
                session?.run(config)
            } else {
                fatalError("Unable to get self discovery token, is this session invalidated?")
            }
        } else {
//            updateInformationLabel(description: "Discovering Peer ...")
            updateInformationLabel(description: "Discovering Peer")
            startupMPC()

            // Set the display state.
            currentDistanceDirectionState = .unknown
        }
    }

    // MARK: - `NISessionDelegate`.

    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }

        // Find the right peer.
        let peerObj = nearbyObjects.first { obj -> Bool in
            obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }

        // Update the the state and visualizations.
        let nextState = getDistanceDirectionState(from: nearbyObjectUpdate)
        updateVisualization(from: currentDistanceDirectionState, to: nextState, with: nearbyObjectUpdate)
        currentDistanceDirectionState = nextState
    }

    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { obj -> Bool in
            obj.discoveryToken == peerToken
        }

        if peerObj == nil {
            return
        }

        currentDistanceDirectionState = .unknown

        switch reason {
        case .peerEnded:
            // The peer token is no longer valid.
            peerDiscoveryToken = nil

            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            session.invalidate()

            // Restart the sequence to see if the peer comes back.
            startup()

            // Update the app's display.
            updateInformationLabel(description: "Peer Ended")
        case .timeout:

            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
//            updateInformationLabel(description: "Peer Timeout")
            updateInformationLabel(description: "Your Peer's Session Timed Out")
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }

    func sessionWasSuspended(_ session: NISession) {
        currentDistanceDirectionState = .unknown
        updateInformationLabel(description: "Session suspended")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        // Session suspension ended. The session can now be run again.
        if let config = self.session?.configuration {
            session.run(config)
        } else {
            // Create a valid configuration.
            startup()
        }
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        currentDistanceDirectionState = .unknown

        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            if #available(iOS 15.0, *) {
                // In iOS 15.0, Settings persists Nearby Interaction access.
                updateInformationLabel(description: "Nearby Interactions access required. You can change access for NIPeekaboo in Settings.")
                // Create an alert that directs the user to Settings.
                let accessAlert = UIAlertController(title: "Access Required",
                                                    message: """
                                                    Link requires access to Nearby Interactions to find your friends.
                                                    """,
                                                    preferredStyle: .alert)
                accessAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                accessAlert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
                    // Send the user to the app's Settings to update Nearby Interactions access.
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }))

                // Display the alert.
//                present(accessAlert, animated: true, completion: nil)
            } else {
                // Before iOS 15.0, ask the user to restart the app so the
                // framework can ask for Nearby Interaction access again.
                updateInformationLabel(description: "Nearby Interactions access required. Restart NIPeekaboo to allow access.")
            }

            return
        }

        // Recreate a valid session.
        startup()
    }

    // MARK: - Discovery token sharing and receiving using MPC.

    func startupMPC() {
        if mpc == nil {
            // Prevent Simulator from finding devices.
            #if targetEnvironment(simulator)
            mpc = MPCSession(service: "nisample", identity: "hacknc.link.simulator", maxPeers: 1)
            #else
            mpc = MPCSession(service: "nisample", identity: "hacknc.link", maxPeers: 1)
            #endif
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }

    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }

        if connectedPeer != nil {
            fatalError("Already connected to a peer.")
        }

        if !sharedTokenWithPeer {
            shareMyDiscoveryToken(token: myToken)
        }
        updateInformationLabel(description: "Connection Found")
        connectedPeer = peer
        peerDisplayName = peer.displayName

    }

    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedTokenWithPeer = false
        }
    }

    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedTokenWithPeer = true
    }

    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        if connectedPeer != peer {
            fatalError("Received token from unexpected peer.")
        }
        // Create a configuration.
        peerDiscoveryToken = token

        let config = NINearbyPeerConfiguration(peerToken: token)

        // Run the session.
        session?.run(config)
    }

    // MARK: - Visualizations

    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }

    func isPointingAt(_ angleRad: Float) -> Bool {
        // Consider the range -15 to +15 to be "pointing at".
        return abs(angleRad.radiansToDegrees) <= 15
    }

    func getDistanceDirectionState(from nearbyObject: NINearbyObject) -> DistanceDirectionState {
        if nearbyObject.distance == nil && nearbyObject.direction == nil {
            return .unknown
        }

        let isNearby = nearbyObject.distance.map(isNearby(_:)) ?? false
        let directionAvailable = nearbyObject.direction != nil

        if isNearby && directionAvailable {
            return .closeUpInFOV
        }

        if !isNearby && directionAvailable {
            return .notCloseUpInFOV
        }

        return .outOfFOV
    }
    
    private func animate(from currentState: DistanceDirectionState, to nextState: DistanceDirectionState, with peer: NINearbyObject) {
        let azimuth = peer.direction.map(azimuth(from:))
        let elevation = peer.direction.map(elevation(from:))

        switch nextState {
        case .closeUpInFOV:
            monkeyLabel = "arrow.up"
        case .notCloseUpInFOV:
            monkeyLabel = "arrow.up"
        case .outOfFOV:
            monkeyLabel = "arrow.up"
        case .unknown:
            monkeyLabel = "questionmark"
        }
        distanceAway = peer.distance
        rotationAmount = azimuth?.radiansToDegrees
        // Don't update visuals if the peer device is unavailable or out of the
        // U1 chip's field of view.
        if nextState == .outOfFOV || nextState == .unknown {
            return
        }
        
    }
    
    func updateVisualization(from currentState: DistanceDirectionState, to nextState: DistanceDirectionState, with peer: NINearbyObject) {
        // Invoke haptics when person is in FOV
        if currentState == .outOfFOV && (nextState == .closeUpInFOV || nextState == .notCloseUpInFOV)  {
            impactGenerator.impactOccurred()
        }
        // Animate into the next visuals.
        
        UIView.animate(withDuration: 0.3, animations: {
            self.animate(from: currentState, to: nextState, with: peer)
        })
    }
}
