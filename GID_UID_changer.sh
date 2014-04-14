#!/usr/bin/env bash

PASSWD=/etc/passwd

function is_int()
{
    number=$1
    label=$2    
    re='^[0-9]+$'
    if ! [[ $number =~ $re ]] ; then
	echo "error: "$label" is  not a number" >&2; exit 1
    fi
}

LOGIN=acorbe
GROUP=acorbe
NEWUID=1012
NEWUID_ARG_NAME="new UID"
NEWGID=1012
NEWUID_ARG_NAME="new GID"

OLDUID=$(id -u $LOGIN)
OLDGID=$(id -g $GROUP)



echo 'User: '$LOGIN
echo -e '\tcurrent UID='$OLDUID
echo -e '\tcurrent GID='$OLDGID

## UID checks

# if [ -z "$NEWUID" ]
# then
#     echo "error: destination UID is empty!"
#     exit 1
# fi
# echo -e 'checking upon new UID ('$NEWUID')...'
# is_int $NEWUID "$NEWUID_ARG_NAME"

# RESULT=`awk -F':' -v U="$NEWUID" '$3==U {print "yes" ; exit}' $PASSWD`

# if [[ -z $RESULT ]]
# then
#     echo "Destination UID is available"
# else 
#     echo "Destination UID exists already. Exiting..." && exit 1
# fi

# ## GID checks

# if [ -z "$NEWGID" ]
# then
#     echo "error: destination GID is empty!"
#     exit 1
# fi
# echo -e 'checking upon new GID ('$NEWGID')...'
# is_int $NEWGID "$NEWGID_ARG_NAME"

# RESULT=`awk -F':' -v U="$NEWUID" '$4==U {print "yes" ; exit}' $PASSWD`

# if [[ -z $RESULT ]]
# then
#     echo "Destination GID is available"
# else 
#     echo "Destination GID exists already. Exiting..." && exit 1
# fi


echo 'assigning new UID('$NEWUID') to user '$LOGIN'...'
usermod --uid $NEWUID $LOGIN

echo 'assigning new GID('$NEWGID') to user '$LOGIN'...'
groupmod -g $NEWGID $GROUP
find / -user $OLDUID -exec chown -h $NEWUID {} \;
find / -group $OLDGID -exec chgrp -h $NEWGID {} \;
usermod --gid $NEWGID $LOGIN

