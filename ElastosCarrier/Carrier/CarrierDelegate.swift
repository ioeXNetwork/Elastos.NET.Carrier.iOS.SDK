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

import Foundation

/**
    The protocol to Carrier node instance.
 */
@objc(ELACarrierDelegate)
public protocol CarrierDelegate {

    /// Tell the delegate that Carrier node will become idle for a while,
    /// during which application can perform instant idle work.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///
    /// - Returns: Void
    @objc(carrierWillBecomeIdle:) optional
    func willBecomeIdle(_ carrier: Carrier)

    /// Tell the delegate that the self connection status changed.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - newStatus: Current connection status. 
    ///                see `CarrierConnectionStatus`
    ///
    /// - Returns: Void
    @objc(carrier:connectionStatusDidChange:) optional
    func connectionStatusDidChange(_ carrier: Carrier,
                                   _ newStatus: CarrierConnectionStatus)

    /// Tell the delegate that Carrier node is being ready.
    ///
    /// Application should wait this callback invoked before calling any 
    /// carrier function to interact with friends.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///
    /// - Returns: Void
    @objc(carrierDidBecomeReady:)
    func didBecomeReady(_ carrier: Carrier)

    /// Tell the delegate that current self user info has been changed.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - newInfo: The newly updated user information
    ///
    /// - Returns: Void
    @objc(carrier:selfUserInfoDidChange:) optional
    func selfUserInfoDidChange(_ carrier: Carrier,
                               _ newInfo: CarrierUserInfo)

    /// Tell the delegate to iterate each friend item in friend list.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - friends: The friends list.
    ///
    @objc(carrier:didReceiveFriendsList:) optional
    func didReceiveFriendsList(_ carrier: Carrier,
                               _ friends: [CarrierFriendInfo])

    /// Tell the delegate that friend connection status has been changed.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - friendId: The friend's user idza z z
    ///   - newStatus: The update
    ///   - newInfo: The updated friend information
    ///
    /// - Returns: Void
    @objc(carrier:friendConnectionDidChange:newStatus:) optional
    func friendConnectionDidChange(_ carrier: Carrier,
                                   _ friendId: String,
                                   _ newStatus: CarrierConnectionStatus)

    /// Tell the delegate that friend information has been changed.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - friendId: The friend's user id
    ///   - newInfo: The updated friend information
    ///
    /// - Returns: Void
    @objc(carrier:friendInfoDidChange:newInfo:) optional
    func friendInfoDidChange(_ carrier: Carrier,
                             _ friendId: String,
                             _ newInfo: CarrierFriendInfo)

    /// Tell the delegate that friend presence has been changed.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - friendId: The friend's user id
    ///   - newPresence: The updated presence status of the friend
    ///
    /// - Returns: Void
    @objc(carrier:friendPresenceDidChange:newPresence:) optional
    func friendPresenceDidChange(_ carrier: Carrier,
                                 _ friendId: String,
                                 _ newPresence: CarrierPresenceStatus)

    /// Tell the delegate that an friend request message has been received.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - userId: The user id who want be friend with current user
    ///   - userInfo: The user information to `userId`
    ///   - hello: The PIN for target user, or any application defined
    ///            content
    ///
    /// - Returns: Void
    @objc(carrier:didReceiveFriendRequestFromUser:withUserInfo:hello:) optional
    func didReceiveFriendRequest(_ carrier: Carrier,
                                 _ userId: String,
                                 _ userInfo: CarrierUserInfo,
                                 _ hello: String)

    /// Tell the delegate that an new friend has been added to current
    /// user's friend list.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - newFriend: The added friend's information
    /// - Returns: Void
    @objc(carrier:newFriendAdded:) optional
    func newFriendAdded(_ carrier: Carrier,
                        _ newFriend: CarrierFriendInfo)

    /// Tell the delegate that an friend has been removed from current user's
    /// friend list.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - friendId: The friend's user id
    ///
    /// - Returns: Void
    @objc(carrier:friendRemoved:) optional
    func friendRemoved(_ carrier: Carrier,
                       _ friendId: String)

    /// Tell the delegate that an friend message has been received.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - from: The id(userid@nodeid) from who send the message
    ///   - message: The message content
    ///
    /// - Returns: Void
    @objc(carrier:didReceiveFriendMessage:withMessage:)optional
    func didReceiveFriendMessage(_ carrier: Carrier,
                                 _ from: String,
                                 _ message: String)

    /// Tell the delegate that an friend invite request has been received.
    ///
    /// - Parameters:
    ///   - carrier: Carrier node instance
    ///   - from: The user id from who send the invite request
    ///   - data: The application defined data sent from friend
    ///
    /// - Returns: Void
    @objc(carrier:didReceiveFriendInviteRequest:withData:) optional
    func didReceiveFriendInviteRequest(_ carrier: Carrier,
                                       _ from: String,
                                       _ data: String)
    
    
    /**
     KJ TEST
     */
    
    ///IOEXCarrier *carrier, const char *friendid, const char *filename, const char *message, void *context)
    @objc(carrier:didReceiveFileQueried:withFileIndex:withFileName:)
    func didReceiveFileQueried(carrier: Carrier,
                               _ friendId: String,
                               _ fileName: String,
                                  message: String)
    
    
    ///file_request callback
    ///IOEXCarrier *carrier, const char *fileid, const char *friendid, const char *filename, size_t filesize, void *context
    @objc(carrier:didReceiveFileRequest:withFileIndex:withFileName:withFileSize:)
    func didReceiveFileRequest(carrier: Carrier,
                                fileid:String,
                            _ friendId: String,
                            _ fileName: String,
                              filesize: Int)
    
    ///IOEXCarrier *carrier, const char *fileid, const char *friendid,const char *fullpath, size_t filesize, void *context
    @objc(carrier:didReceiveFileAccepted:withFileIndex:withFilepath:withSize:)
    func didReceiveFileAccepted(carrier: Carrier,
                                 fileid: String,
                               friendId: String,
                               fullpath: String,
                                 size_t: Int)
    
    ///                      IOEXCarrier *carrier, const char *fileid, const char *friendid,void *context)
    @objc(carrier:didReceiveFileRejected:withFriendId:)
    func didReceiveFileRejected(carrier: Carrier,
                               _ fileid: String,
                               friendid: String	)

    ///void (*file_paused)(IOEXCarrier *carrier, const char *friendid, const uint32_t fileindex,void *context);
    ///                    IOEXCarrier *carrier, const char *fileid, const char *friendid,void *context)
    @objc(carrier:didReceiveFilePaused:withFriendId:)
    func didReceiveFilePaused(carrier: Carrier,
                              _ fileid: String,
                              friendid: String    )
    
    ///void (*file_resumed)(IOEXCarrier *carrier, const char *fileid, const char *friendid,void *context);
    @objc(carrier:didReceiveFileResumed:withFriendId:)
    func didReceiveFileResumed(carrier: Carrier,
                               _ fileid: String,
                               friendid: String    )
    
    ///void (*file_canceled)(IOEXCarrier *carrier, const char *fileid, const char *friendid,void *context);
    @objc(carrier:didReceiveFileCanceled:withFriendId:)
    func didReceiveFileCanceled(carrier: Carrier,
                                _ fileid: String,
                                friendid: String    )
    
    ///void (*file_completed)(IOEXCarrier *carrier, const char *fileid, const char *friendid, void *context);
    @objc(carrier:didReceiveFileCompleted:withFriendId:)
    func didReceiveFileCompleted(carrier: Carrier,
                                _ fileid: String,
                                friendid: String    )

    ///void (*file_progress)(IOEXCarrier *carrier, const char *fileid, const char *friendid,const char *fullpath, uint64_t size, uint64_t transferred, void *context);
    @objc(carrier:didReceiveFileProgress:withFileId:withFriendId:withFullpath:withFileSize:)
    func didReceiveFileProgress(carrier: Carrier,
                                  _ fileid: String,
                                  friendid: String,
                                  fullpath: String,
                                      size: Int64,
                               transferred: Int64)
//    ///var file_chunk_send: (@convention(c)(OpaquePointer?, UnsafePointer<Int8>?, UInt32, UnsafePointer<Int8>?, UInt64, Int, UnsafeMutableRawPointer?) -> Swift.Void)!
//    ///void (*file_chunk_send)(IOEXCarrier *carrier, const char *friendid, const uint32_t fileindex,const char *filename, const uint64_t position, const size_t length,void *context);
//    @objc(carrier:didReceiveFileChunkSend:withFileIndex:withFileName:withPosition:withLength:)
//    func didReceiveFileChunkSend(carrier: Carrier,
//                                friendId: String,
//                                fileindex: Int32,
//                                fileName: String,
//                                 position: Int64,
//                                length: Int)
//
//    ///var file_chunk_send_error: (@convention(c)(OpaquePointer?, Int, UnsafePointer<Int8>?, UInt32, UnsafePointer<Int8>?, UInt64, Int, UnsafeMutableRawPointer?) -> Swift.Void)!
//    ///void (*file_chunk_send_error)(IOEXCarrier *carrier, int errcode, const char *friendid, const uint32_t fileindex,const char *fullpath, const uint64_t position, const size_t length, void *context);
//    @objc(carrier:didReceiveFileChunkSendError:withFRIENDId:withFileIndex:withFileName:withPosition:withLength:)
//    func didReceiveFileChunkSendError(carrier: Carrier,
//                                    errorCode: Int,
//                                     friendId: String,
//                                    fileindex: Int32,
//                                     fullpath: String,
//                                     position: Int64,
//                                       length: Int)
//
//    ///var file_chunk_receive: (@convention(c)(OpaquePointer?, UnsafePointer<Int8>?, UInt32, UnsafePointer<Int8>?, UInt64, Int, UnsafeMutableRawPointer?) -> Swift.Void)!
//    ///void (*file_chunk_receive)(IOEXCarrier *carrier, const char *friendid, const uint32_t fileindex,const char *filename, const uint64_t position, const size_t length,void *context)
//    @objc(carrier:didReceiveFileChunkReceive:withFileIndex:withFileName:withPosition:withLength:)
//    func didReceiveFileChunkReceive(carrier: Carrier,
//                                    friendId: String,
//                                    fileindex: Int32,
//                                    fileName: String,
//                                    position: Int64,
//                                    length: Int)
    
    /**************/
//    @objc(carrier:ReceivedComplete:)
//    func didTSFileReceivedComplete(_FileName: String,_RealFileName: String)
}




