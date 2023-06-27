//
//  main.swift
//  MountShares
//
//  Created by Eric Hemmeter on 6/26/23.
//  With help from https://gist.github.com/mosen/2ddf85824fbb5564aef527b60beb4669, https://gist.github.com/pudquick/1362a8908be01e23041d, and https://developer.apple.com/forums/thread/94733

import Foundation
import ArgumentParser
import NetFS

@main
struct MountShares: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "MountShares",
        abstract: "Mount network shares the way \"Connect to Server…\" does",
        discussion: """
The default usage assumes the needed credentials are in the user's keychain or the server uses Kerberos.  Otherwise, a username and password can be passed in, or the system can prompt for authentication with a GUI window.  The various mounting and opening options are available as command line flags.  This command should be run as the user that is mounting the share.
""",
        version: "1.0.0"
        )
    @Flag(name: .shortAndLong, help: "Print success or error message to STDOUT") var verbose: Bool = false
    @Option(name: .shortAndLong, help: "If necessary, specify a username to mount the share as.") var username: String?
    @Option(name: .shortAndLong, help: "Works with username to mount the share as a different user") var password: String?
    @Option(help: "To change the local mountpoint.  The default is /Volumes/") var localPath: String?
    @Flag(help: "No browsable data here (see <sys/mount.h>)") var nobrowse: Bool = false
    @Flag(help: "A read-only mount (see <sys/mount.h>)") var readonly: Bool = false
    @Flag(help: "Allow a mount from a dir beneath the share point") var allowSubMounts: Bool = false
    @Flag(help: "Mount with \"soft\" failure semantics") var softMount: Bool = false
    @Flag(help: "Mount on the specified mountpath instead of below it") var mountAtDirectory: Bool = false
    @Flag(help: "Login as a guest user") var guest: Bool = false
    @Flag(help: "Allow a loopback mount") var allowLoopback: Bool = false
    @Flag(help: "The default GUI authentication window option, displays if needed") var allowAuthDialog: Bool = false
    @Flag(help: "Do not allow a GUI authentication window") var noAuthDialog: Bool = false
    @Flag(help: "Force a GUI authentication window") var forceAuthDialog: Bool = false
    @Argument(help: "The full path to the share to mount i.e. \"smb://server.domain.tld/share\"") var serverSharePath: String
    
    mutating func validate() throws {
        guard ( username == nil && password == nil ) || ( username != nil && password == nil ) || ( username != nil && password != nil ) else {
            throw ValidationError("If a password is set, username must both be set")
        }
    }
    
    mutating func run() throws {
        let mountOptions: NSMutableDictionary = NSMutableDictionary()
        let openOptions: NSMutableDictionary = NSMutableDictionary()
        
        if nobrowse {
            if let existingValue = mountOptions.value(forKey: kNetFSMountFlagsKey) {
                mountOptions[kNetFSMountFlagsKey] = existingValue as! Int32 | MNT_DONTBROWSE
            } else {
                mountOptions[kNetFSMountFlagsKey] = MNT_DONTBROWSE
            }
        }
        if readonly {
            if let existingValue = mountOptions.value(forKey: kNetFSMountFlagsKey) {
                mountOptions[kNetFSMountFlagsKey] = existingValue as! Int32 | MNT_RDONLY
            } else {
                mountOptions[kNetFSMountFlagsKey] = MNT_RDONLY
            }
        }
        if allowSubMounts {
            mountOptions[kNetFSAllowSubMountsKey] = true
        }
        if softMount {
            mountOptions[kNetFSSoftMountKey] = true
        }
        if mountAtDirectory {
            mountOptions[kNetFSMountAtMountDirKey] = true
        }
        
        if guest {
            openOptions[kNetFSUseGuestKey] = true
        }
        if allowLoopback {
            openOptions[kNetFSAllowLoopbackKey] = true
        }
        if noAuthDialog {
            openOptions[kNAUIOptionKey] = kNAUIOptionNoUI
        }
        if allowAuthDialog {
            openOptions[kNAUIOptionKey] = kNAUIOptionAllowUI
        }
        if forceAuthDialog {
            openOptions[kNAUIOptionKey] = kNAUIOptionForceUI
        }
        
        
        let sharePathURL = URL(string: serverSharePath)
        var localPathURL = URL(string: "")
        if localPath != nil  {
            localPathURL = URL(string: localPath!)
        } else {
            localPathURL = nil
        }
        let mounted: Int32 = NetFSMountURLSync(sharePathURL as CFURL?, localPathURL as CFURL?, username as CFString?, password as CFString?, openOptions, mountOptions, nil)
        if verbose {
            if mounted != 0 {
                print("Error \(mounted): \(serverSharePath) Not Mounted")
            } else {
                print("Mounted: \(serverSharePath)")
            }
        }
    }
}



