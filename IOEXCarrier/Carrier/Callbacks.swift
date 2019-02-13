/*
 * Copyright (c) 2018 Elastos Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * Copyright (c) 2019 ioeXNetwork
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Foundation

@inline(__always)
func getCarrier(_ cctxt: UnsafeMutableRawPointer) -> Carrier {
    return Unmanaged<Carrier>.fromOpaque(cctxt).takeUnretainedValue()
}

private func onIdle(_: OpaquePointer?, cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    handler.willBecomeIdle?(carrier)
}

private func onConnection(_: OpaquePointer?, cstatus: UInt32,
                          cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let status  = CarrierConnectionStatus(rawValue: Int(cstatus))!
    let handler = carrier.delegate!

    handler.connectionStatusDidChange?(carrier, status)
}

private func onReady(_: OpaquePointer?, cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    handler.didBecomeReady(carrier)
}

private func onSelfInfoChanged(_: OpaquePointer?,
                               cinfo: UnsafeRawPointer?,
                               cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let cUserInfo = cinfo!.assumingMemoryBound(to: CUserInfo.self).pointee
    let info = convertCUserInfoToCarrierUserInfo(cUserInfo)

    handler.selfUserInfoDidChange?(carrier, info)
}

private func onFriendIterated(_: OpaquePointer?,
                              cinfo: UnsafeRawPointer?,
                              cctxt: UnsafeMutableRawPointer?) -> CBool {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    if (cinfo != nil) {
        let cFriendInfo = cinfo!.assumingMemoryBound(to: CFriendInfo.self).pointee
        let info = convertCFriendInfoToCarrierFriendInfo(cFriendInfo)
        carrier.friends.append(info)
    } else {
        handler.didReceiveFriendsList?(carrier, carrier.friends)
        carrier.friends.removeAll()
    }

    return true
}

private func onFriendConnectionChanged(_: OpaquePointer?,
                                       cfriendId: UnsafePointer<Int8>?,
                                       cstatus: UInt32,
                                       cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let friendId = String(cString: cfriendId!)
    let status = CarrierConnectionStatus(rawValue: Int(cstatus))!

    handler.friendConnectionDidChange?(carrier, friendId, status)
}

private func onFriendInfoChanged(_: OpaquePointer?,
                                 cfriendId: UnsafePointer<Int8>?,
                                 cinfo: UnsafeRawPointer?,
                                 cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let friendId = String(cString: cfriendId!)
    let cFriendInfo = cinfo!.assumingMemoryBound(to: CFriendInfo.self).pointee
    let info = convertCFriendInfoToCarrierFriendInfo(cFriendInfo)

    handler.friendInfoDidChange?(carrier,friendId, info)
}

private func onFriendPresence(_: OpaquePointer?,
                              cfriendId: UnsafePointer<Int8>?,
                              cpresence: UInt32,
                              cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let friendId = String(cString: cfriendId!)
    let presence = CarrierPresenceStatus(rawValue: Int(cpresence))!

    handler.friendPresenceDidChange?(carrier, friendId, presence)
}

private func onFriendRequest(_: OpaquePointer?,
                             cuserId: UnsafePointer<Int8>?,
                             cinfo: UnsafeRawPointer?,
                             chello: UnsafePointer<Int8>?,
                             cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let userId = String(cString: cuserId!)
    let cUserInfo = cinfo!.assumingMemoryBound(to: CUserInfo.self).pointee
    let info   = convertCUserInfoToCarrierUserInfo(cUserInfo)
    let hello  = String(cString: chello!)

    handler.didReceiveFriendRequest?(carrier, userId, info, hello)
}

private func onFriendAdded(_: OpaquePointer?,
                           cinfo: UnsafeRawPointer?,
                           cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let cFriendInfo = cinfo!.assumingMemoryBound(to: CFriendInfo.self).pointee
    let info = convertCFriendInfoToCarrierFriendInfo(cFriendInfo)

    handler.newFriendAdded?(carrier, info)
}

private func onFriendRemoved(_: OpaquePointer?,
                             cfriendId: UnsafePointer<Int8>?,
                             cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let friendId = String(cString: cfriendId!)
    handler.friendRemoved?(carrier, friendId)
}

private func onFriendMessage(_: OpaquePointer?, cfrom: UnsafePointer<Int8>?,
                             cmessage: UnsafePointer<Int8>?, _: Int,
                             cctxt: UnsafeMutableRawPointer?) {

    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let from = String(cString: cfrom!)
    let msg  = String(cString: cmessage!)

    handler.didReceiveFriendMessage?(carrier, from, msg)
}

private func onFriendInvite(_: OpaquePointer?, cfrom: UnsafePointer<Int8>?,
                            cdata: UnsafePointer<Int8>?, _: Int,
                            cctxt: UnsafeMutableRawPointer?) {
    let carrier = getCarrier(cctxt!)
    let handler = carrier.delegate!

    let from = String(cString: cfrom!)
    let data = String(cString: cdata!)

    handler.didReceiveFriendInviteRequest?(carrier, from, data)
}


private func onReceiveFileQueried(_: OpaquePointer?,
                                  friendid: UnsafePointer<Int8>?,
                                  filename: UnsafePointer<Int8>?,
                                  cmessage: UnsafePointer<Int8>?,
                                  context: UnsafeMutableRawPointer?){
    
    let carrier = getCarrier(context!)
    let handler = carrier.delegate!
    
    let file_name = String(cString: filename!)
    let friend_id = String(cString: friendid!)
    let message = String(cString: cmessage!)
    
    handler.didReceiveFileQueried(carrier: carrier, friend_id, file_name, message: message)
}


private func onReceiveFileRequest(_: OpaquePointer?,
                                  _ fileid: UnsafePointer<Int8>?,
                                  friendid: UnsafePointer<Int8>?,
                                  filename: UnsafePointer<Int8>?,
                                  filesize: Int,
                                  context: UnsafeMutableRawPointer?){
    
    let carrier = getCarrier(context!)
    let handler = carrier.delegate!
    
    let file_name = String(cString: filename!)
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFileRequest(carrier: carrier, fileid: file_id, friend_id, file_name, filesize: filesize)
}

private func onReceiveFileAccepted(_: OpaquePointer?,
                                   fileid:UnsafePointer<Int8>?,
                                  _ friendid: UnsafePointer<Int8>?,
                                  _ fullpath: UnsafePointer<Int8>?,
                                    filesize:Int,
                                  _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    let full_path = String(cString: fullpath!)
    
    handler.didReceiveFileAccepted(carrier: ca, fileid: file_id, friendId: friend_id, fullpath: full_path, size_t: filesize)
}

private func onReceiveFileRejected(_: OpaquePointer?,
                                     fileid: UnsafePointer<Int8>?,
                                   _ friendid: UnsafePointer<Int8>?,
                                   _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFileRejected(carrier: ca, file_id, friendid: friend_id)
}

private func onReceiveFilePaused(_: OpaquePointer?,
                                 fileid: UnsafePointer<Int8>?,
                                 _ friendid: UnsafePointer<Int8>?,
                                 _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFilePaused(carrier: ca, file_id, friendid: friend_id)
}

private func onReceiveFileResumed(_: OpaquePointer?,
                                  fileid: UnsafePointer<Int8>?,
                                  _ friendid: UnsafePointer<Int8>?,
                                  _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFileResumed(carrier: ca, file_id, friendid: friend_id)
}

private func onReceiveFileCanceled(_: OpaquePointer?,
                                   fileid: UnsafePointer<Int8>?,
                                   _ friendid: UnsafePointer<Int8>?,
                                   _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFileCanceled(carrier: ca, file_id, friendid: friend_id)
}

private func onReceiveFileCompleted(_: OpaquePointer?,
                                   fileid: UnsafePointer<Int8>?,
                                   _ friendid: UnsafePointer<Int8>?,
                                   _ context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    
    handler.didReceiveFileCompleted(carrier: ca, file_id, friendid: friend_id)
}

private func onReceiveFileProgress(_: OpaquePointer?,
                                   fileid: UnsafePointer<Int8>?,
                                   friendid: UnsafePointer<Int8>?,
                                   fullpath:UnsafePointer<Int8>?,
                                   size :UInt64,
                                   transferred:UInt64,
                                   context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    let full_path = String(cString: fullpath!)
    
    handler.didReceiveFileProgress(carrier: ca, file_id, friendid: friend_id, fullpath: full_path, size: Int64(size), transferred: Int64(transferred))
}

private func onReceiveFileAborted(_: OpaquePointer?,
                                   fileid: UnsafePointer<Int8>?,
                                   friendid: UnsafePointer<Int8>?,
                                   filename:UnsafePointer<Int8>?,
                                   length :Int,
                                   filesize:Int,
                                   context: UnsafeMutableRawPointer?){
    
    let ca = getCarrier(context!)
    let handler = ca.delegate!
    
    let friend_id = String(cString: friendid!)
    let file_id = String(cString: fileid!)
    let file_name = String(cString: filename!)
    
    handler.didReceiveFileAborted(carrier: ca, file_id, friendid: friend_id, filename: file_name, length: length, filesize: filesize)
}

internal func getNativeHandlers() -> CCallbacks {

    var callbacks = CCallbacks()

    callbacks.idle = onIdle
    callbacks.connection_status = onConnection
    callbacks.ready = onReady
    callbacks.self_info = onSelfInfoChanged
    callbacks.friend_list = onFriendIterated
    callbacks.friend_info = onFriendInfoChanged
    callbacks.friend_connection = onFriendConnectionChanged
    callbacks.friend_presence = onFriendPresence
    callbacks.friend_request = onFriendRequest
    callbacks.friend_added = onFriendAdded
    callbacks.friend_removed = onFriendRemoved
    callbacks.friend_message = onFriendMessage
    callbacks.friend_invite = onFriendInvite
    callbacks.file_queried =  onReceiveFileQueried
    callbacks.file_request = onReceiveFileRequest
    callbacks.file_accepted = onReceiveFileAccepted
    callbacks.file_rejected = onReceiveFileRejected
    callbacks.file_paused = onReceiveFilePaused
    callbacks.file_resumed = onReceiveFileResumed
    callbacks.file_completed = onReceiveFileCompleted
    callbacks.file_progress = onReceiveFileProgress
    callbacks.file_aborted = onReceiveFileAborted
    return callbacks
}
