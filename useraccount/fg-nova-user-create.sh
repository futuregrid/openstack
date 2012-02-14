# nova user creation script
# sharif islam
# islamsh@indiana.edu

if [ -z "$1" ]; then
              echo usage: $0 username
              exit
          fi
USERNAME=$1
NOVAFILE=$USERNAME-nova.zip
HOMEDIR=/server/$USERNAME
NOVADIR="NOVA_FOLDERNAME"
NOVANODE="IP_ADDRESS_OF_NOVA_MGMT_NODE"


if [ -f /$HOMEDIR/$NOVAFILE ]
  then
    echo "$NOVAFILE already exists."
else

  echo " ..... creating nova user $USERNAME in OpenStack cactus in
$NOVANODE ...... "
   nova-manage user create $USERNAME
 nova-manage project add fguser $USERNAME
  nova-manage role add $USERNAME netadmin
   nova-manage role add $USERNAME netadmin fguser
   nova-manage role add $USERNAME sysadmin
  nova-manage role add $USERNAME sysadmin fguser
   nova-manage project zipfile fguser $USERNAME $NOVADIR/$USERNAME-nova.zip
 zip $NOVADIR/$USERNAME-nova.zip $NOVADIR/runinstance.sh
  zip $NOVADIR/$USERNAME-nova.zip $NOVADIR/allip.sh

 # now copy the file to the user homedir
  echo "copying $USERNAME-nova.zip to home directory"
  scp $NOVANODE:$NOVADIR/$USERNAME-nova.zip $HOMEDIR/.

  echo "Fixing ownership"
        chown $USERNAME:users $HOMEDIR/$NOVAFILE
        chmod 600 $HOMEDIR/$NOVAFILE
  echo "nova user $USERNAME created .....";
fi
