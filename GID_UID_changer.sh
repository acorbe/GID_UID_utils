#!/usr/bin/env bash

PASSWD=/etc/passwd

NARGS=4

if [ $# -ne $NARGS ]; then
    echo error: wrong number of arguments should be $NARGS and it is $#.
    echo usage: $0 LOGIN GROUP NEWID NEWGID
    exit 1
fi

LOGIN=$1
GROUP=$2
NEWUID=$3
NEWGID=$4

## checking if by any means user is logged (e.g. via ssh)

USER_LOGGED=`w -h -u $LOGIN`

if [[ -z $USER_LOGGED ]]; then
    echo 'User is not logged! Proceeding...'
else
    echo 'error: User is logged! Exiting...'
    exit 1
fi


function is_int()
{
    number=$1
    label=$2    
    re='^[0-9]+$'
    if ! [[ $number =~ $re ]] ; then
	echo "error: "$label" is  not a number" >&2; exit 1
    fi
}


NEWUID_ARG_NAME="new UID"
NEWUID_ARG_NAME="new GID"

OLDUID=$(id -u $LOGIN)
OLDGID=$(id -g $GROUP)



echo 'User: '$LOGIN
echo -e '\tcurrent UID='$OLDUID
echo -e '\tcurrent GID='$OLDGID

## UID checks

if [ -z "$NEWUID" ]
then
    echo "error: destination UID is empty!"
    exit 1
fi
echo -e 'checking upon new UID ('$NEWUID')...'
is_int $NEWUID "$NEWUID_ARG_NAME"

RESULT=`awk -F':' -v U="$NEWUID" '$3==U {print "yes" ; exit}' $PASSWD`

if [[ -z $RESULT ]]
then
    echo "Destination UID is available"
else 
    echo "Destination UID exists already. Exiting..." && exit 1
fi

## GID checks

if [ -z "$NEWGID" ]
then
    echo "error: destination GID is empty!"
    exit 1
fi
echo -e 'checking upon new GID ('$NEWGID')...'
is_int $NEWGID "$NEWGID_ARG_NAME"

RESULT=`awk -F':' -v U="$NEWUID" '$4==U {print "yes" ; exit}' $PASSWD`

if [[ -z $RESULT ]]
then
    echo "Destination GID is available"
else 
    echo "Destination GID exists already. Exiting..." && exit 1
fi


echo 'assigning new UID('$NEWUID') to user '$LOGIN'...'
usermod --uid $NEWUID $LOGIN

echo 'assigning new GID('$NEWGID') to user '$LOGIN'...'
groupmod -g $NEWGID $GROUP

echo 'changing files UID...'
find / -user $OLDUID -exec chown -h $NEWUID {} \;

echo 'changing files GID...'
find / -group $OLDGID -exec chgrp -h $NEWGID {} \;

echo 'changing '
usermod --gid $NEWGID $LOGIN

