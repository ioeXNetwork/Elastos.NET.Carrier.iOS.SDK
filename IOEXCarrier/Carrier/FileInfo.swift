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

import Foundation;

@objc(ELAFileInfo)
public class FileInfo: NSObject {
    
    private var _file_name       : String?
    private var _file_path       : String?
    private var _friend_number   : Int32 = 0
    private var _file_index      : Int32 = 0
    
    /***/
    public var file_name  : String?  {
        set {
            _file_name = newValue
        }
        get {
            return _file_name
        }
    }
    
    /***/
    public var file_path: String?  {
        set {
            _file_path = newValue
        }
        get {
            return _file_path
        }
    }
    
    /***/
    public var friend_number: Int32  {
        set {
            _friend_number = newValue
        }
        get {
            return _friend_number
        }
    }
    
    /***/
    public var file_index: Int32  {
        set {
            _file_index = newValue
        }
        get {
            return _file_index
        }
    }
    
    internal static func format(_ file_info: FileInfo) -> String {
        return String(format: "file_name[%@], file_path[%@], friend_number[%@], file_index[%@]",
                      String.toHardString(file_info.file_name),
                      String.toHardString(file_info.file_path),
                      String.toHardString(file_info.friend_number.description),
                      String.toHardString(file_info.file_index.description))
    }
    
    public override var description: String {
        return FileInfo.format(self)
    }
}

internal func convertFileInfoToCFileInfo(_ info: FileInfo) -> CFileInfo {
    var cInfo = CFileInfo()
    
    info.file_name?.writeToCCharPointer(&cInfo.file_name)
    info.file_path?.writeToCCharPointer(&cInfo.file_path)
    info.friend_number.description.writeToCCharPointer(&cInfo.friend_number)
    info.file_index.description.writeToCCharPointer(&cInfo.file_index)
    
    return cInfo
}

internal func convertCFileInfoToFileInfo(_ cInfo: CFileInfo) -> FileInfo {
    let info = FileInfo()
    var temp = cInfo
    
    info.file_name = String(cCharPointer: &temp.file_name)
    info.file_path = String(cCharPointer: &temp.file_path)
    info.friend_number = temp.friend_number
    info.file_index = temp.file_index
    
    return info
}
