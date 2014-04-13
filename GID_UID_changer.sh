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

NEWUID=1001
NEWUID_ARG_NAME="new UID"
NEWGID=

OLDUID=$(id -u $LOGIN)
OLDGID=$(id -g $GROUP)

echo 'User: '$LOGIN
echo -e '\tcurrent UID='$OLDUID
echo -e '\tcurrent GID='$OLDGID

if [ -z "$NEWUID" ]
then
    echo "error: destination UID is empty!"
    exit 1
fi
echo -e 'checking upon new UID ('$NEWUID')...'
is_int $NEWUID "$NEWUID_ARG_NAME"

RESULT=`awk -F':' -v U="$NEWUID" '$3==U {print "yes" ; exit}' /etc/passwd`
 
[ -z $RESULT ] && echo "Already Exists..Exiting..." && exit 1

# awk -F':' '{if($3 == 1001) print  $1; exit 1}' $PASSWD
# awk -F':' '{echo suca $1 }' $PASSWD
#awk -F':' '{print $1}' $PASSWD

echo 'assigning new UID('$NEWUID') to user '$LOGIN'...'
# usermod --uid $NEWUID $LOGIN
# groupmod -g $NEWGID $GROUP
# find / -user $OLDUID -exec chown -h $NEWUID {} \;
# find / -group $OLDGID -exec chgrp -h $NEWGID {} \;
# usermod --gid $NEWGID $LOGIN

