# MountShare  
```
OVERVIEW: Mount network shares the way "Connect to Server…" does

The default usage assumes the needed credentials are in the user's keychain or the server uses Kerberos.
Otherwise, a username and password can be passed in, or the system can prompt for authentication with a GUI window.
The various mounting and opening options are available as command line flags.
This command should be run as the user that is mounting the share.

USAGE: mountshare [<options>] <server-share-path>

ARGUMENTS:
  <server-share-path>     The full path to the share to mount i.e. "smb://server.domain.tld/share"

OPTIONS:
  -v, --verbose           Print success or error message to STDOUT
  -u, --username <username>
                          If necessary, specify a username to mount the share as.
  -p, --password <password>
                          Works with username to mount the share as a different user
  --local-path <local-path>
                          To change the local mountpoint.  The default is /Volumes/
  --nobrowse              No browsable data here (see <sys/mount.h>)
  --readonly              A read-only mount (see <sys/mount.h>)
  --allow-sub-mounts      Allow a mount from a dir beneath the share point
  --soft-mount            Mount with "soft" failure semantics
  --mount-at-directory    Mount on the specified mountpath instead of below it
  --guest                 Login as a guest user
  --allow-loopback        Allow a loopback mount
  --allow-auth-dialog     The default GUI authentication window option, displays if needed
  --no-auth-dialog        Do not allow a GUI authentication window
  --force-auth-dialog     Force a GUI authentication window
  --version               Show the version.
  -h, --help              Show help information.
```
This project was inspired by [my previous use](https://sneakypockets.wordpress.com/2016/09/26/mounting-file-shares-based-on-ad-group-membership-using-enterprise-connect/) of [mount_shares_better.py](https://gist.github.com/pudquick/1362a8908be01e23041d).  Then I found useful information on Apple's [developer forums](https://developer.apple.com/forums/thread/94733) and a lot of help from a gist of [a library](https://gist.github.com/mosen/2ddf85824fbb5564aef527b60beb4669) to do the same things.  
