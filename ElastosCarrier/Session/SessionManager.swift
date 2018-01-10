import Foundation

@inline(__always) private func TAG() -> String { return "CarrierSessionManager" }

public typealias CarrierSessionRequestHandler = (_ carrier: Carrier,
                                       _ from: String, _ sdp: String) -> Void

/// The class representing carrier session manager.
@objc(ELACarrierSessionManager)
public class CarrierSessionManager: NSObject {

    private static var sessionMgr: CarrierSessionManager?

    private var carrier: Carrier?
    private var handler: CarrierSessionRequestHandler?
    private var didCleanup: Bool

    /// Get a carrier session manager instance.
    ///
    /// This function is convinience way to get instance without interest to
    /// session request from friends.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - options: The options to set for carrier session manager
    ///
    /// - Returns: A carrier session manager
    ///
    /// - Throws: CarrierError
    @objc(getInstance:error:)
    public static func getInstance(carrier: Carrier)
        throws -> CarrierSessionManager {

        if (sessionMgr != nil && sessionMgr!.carrier != carrier) {
            sessionMgr!.cleanup()
        }

        if (sessionMgr == nil) {
            Log.d(TAG(), "Begin to initialize native carrier session manager...")

            let result = ela_session_init(carrier.ccarrier, nil, nil)

            guard result >= 0 else {
                let errno = getErrorCode()
                Log.e(TAG(), "Initialize native session manager error:0x%X", errno)
                throw CarrierError.InternalError(errno: errno)
            }

            Log.d(TAG(), "The native carrier session manager initialized.")

            sessionMgr = CarrierSessionManager(carrier)
            sessionMgr!.didCleanup = false

            Log.i(TAG(), "Native carrier session manager instance created.");
        }

        return sessionMgr!
    }

    /// Get a carrier session manager instance.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - options: The options to set for carrier session manager.
    ///   - handler: The handler for carrier session manager to process session
    ///              request from friends.
    ///
    /// - Returns: A carrier session manager
    ///
    /// - Throws: CarrierError
    @objc(getInstance:usingHandler:error:)
    public static func getInstance(carrier: Carrier,
                                   handler: @escaping CarrierSessionRequestHandler)
        throws -> CarrierSessionManager {

        if (sessionMgr != nil && sessionMgr!.carrier != carrier) {
            sessionMgr!.cleanup()
        }

        if (sessionMgr == nil) {

            Log.d(TAG(), "Begin to initialize native carrier session manager...")

            let cb: CSessionRequestCallback = { (_, cfrom, csdp, _, cctxt) in
                let manager = Unmanaged<CarrierSessionManager>
                        .fromOpaque(cctxt!).takeUnretainedValue()

                let carrier = manager.carrier
                let handler = manager.handler

                let from = String(cString: cfrom!)
                let  sdp = String(cString: csdp!)

                handler!(carrier!, from, sdp)

            }

            let sessionManager = CarrierSessionManager(carrier)
            sessionManager.handler = handler

            let cctxt = Unmanaged.passUnretained(sessionManager).toOpaque()

            let result = ela_session_init(carrier.ccarrier, cb, cctxt)

            guard result >= 0 else {
                let errno = getErrorCode()
                Log.e(TAG(), "Initialize native session manager error: 0x%X", errno)
                throw CarrierError.InternalError(errno: errno)
            }

            Log.d(TAG(), "The native carrier session manager initialized.")

            sessionManager.didCleanup = false
            sessionMgr = sessionManager

            Log.i(TAG(), "Native carrier session manager instance created.");
        }

        return sessionMgr!;
    }

    /// Get a carrier session manager instance.
    ///
    /// - Returns: The carrier session manager or nil
    public static func getInstance() -> CarrierSessionManager? {
        return sessionMgr;
    }

    private init(_ carrier: Carrier) {
        self.carrier = carrier
        self.didCleanup = true
    }

    deinit {
        cleanup()
    }

    ///  Clean up carrier session manager.
    public func cleanup() {

        objc_sync_enter(self)
        if !didCleanup {
            Log.d(TAG(), "Begin clean up native carrier session manager ...")

            ela_session_cleanup(carrier!.ccarrier)
            carrier = nil
            CarrierSessionManager.sessionMgr = nil
            didCleanup = true

            Log.i(TAG(), "Native carrier session managed cleanuped.")
        }
        objc_sync_exit(self)
    }

    /// Create a new session converstation to the specified friend.
    ///
    /// The session object represent a conversation handle to a friend.
    ///
    /// - Parameters:
    ///   - target:    The target id.
    ///
    /// - Returns: The new CarrierSession
    ///
    /// - Throws: CarrierError
    public func newSession(to target: String)
        throws -> CarrierSession {

        let ctmp = target.withCString { (ptr) -> OpaquePointer? in
            return ela_session_new(carrier!.ccarrier, ptr)
        }

        guard ctmp != nil else {
            let errno = getErrorCode()
            Log.e(TAG(), "Open session conversation to \(target) error: 0x%X", errno)
            throw CarrierError.InternalError(errno: errno)
        }

        Log.i(TAG(), "An new session to \(target) created locally.")

        return CarrierSession(ctmp!, target)
    }
}
