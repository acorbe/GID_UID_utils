GID_UID_utils
=============

Shell scripts to handle GID and UID operations like ID changing and swapping.

These operations are particularly useful e.g. when setting up a NFS share, which needs GID and UID to be consistent across the network.


USAGE:

+ **aim:** given a user (say `acorbe`) and a group (say `gacorbe`), one wants to change his UID and the GID referring to his group. If the desired UID is `1001` and the desired GID is `1001`, the operation can be done via
        
        # GID_UID_changer.sh    acorbe  gacorbe  1001  1001
  *caveats:* target user (`acorbe`) must not be connected to the machine (either directly or remotely)

  *sources:* This scripts expands (by adding consistency checks) the following constributions
    
  + https://muffinresearch.co.uk/linux-changing-uids-and-gids-for-user/
  + http://askubuntu.com/questions/312919/how-to-change-user-gid-and-uid-in-ubuntu-13-04
  
  
 
