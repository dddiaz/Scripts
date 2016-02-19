#!/bin/sh

echo "Uploading danieldelvindiaz.com to aws!"

echo "Creating temp dir"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# the temp directory used, within $DIR
WORK_DIR=`mkdir $DIR/tempTransferFolder`

# deletes the temp directory
function cleanup {
  rm -rf $DIR/tempTransferFolder
  echo "Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

# Implementation of script starts here
echo "Downloading Code from Github"
cd $DIR/tempTransferFolder
curl -L -o master.zip https://github.com/dddiaz/danieldelvindiaz.com/zipball/master
echo "Done Downloading"
unzip master.zip
rm -rf master.zip
# CD into first available directory, which is the site
cd $(ls -d */|head -n 1)
echo "Syncing with aws"

aws s3 sync . s3://danieldelvindiaz.com

cd ../../

echo "Done"

exit
