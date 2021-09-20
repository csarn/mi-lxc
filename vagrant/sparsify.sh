#!/usr/bin/env bash

set -e

# Get HD filename
FILENAME=`vboxmanage showvminfo milxc-debian-amd64 | grep SATA | grep UUID | cut -d':' -f2 | cut -d'(' -f1 | sed -e 's/^[ \t]*//' |  sed -e 's/[ \t]*$//'`

# Split the dir and filename
DIR=`dirname "$FILENAME"`
FILE=`basename "$FILENAME"`

# Get HD UUID
UUID=`vboxmanage showvminfo milxc-debian-amd64 | grep SATA | grep UUID | cut -d':' -f 3| cut -d')' -f1 | sed -e 's/^[ \t]*//' |  sed -e 's/[ \t]*$//'`

# echo -e $DIR
# echo -e $FILE
# echo -e $UUID

mv "$DIR/$FILE" "$DIR/old.vmdk"
virt-sparsify "$DIR/old.vmdk" "$DIR/$FILE"
vboxmanage internalcommands sethduuid "$DIR/$FILE" $UUID
echo "Old virtual disk has been moved to $DIR/old.vmdk, you can now confirm its deletion"
rm -i "$DIR/old.vmdk"