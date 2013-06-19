#!/bin/bash
FORMAT_FILES="mission.sqm"
cd avdworld.Stratis
git pull
BUILDNUM=$(git log |grep -E "^commit" | wc -l)
#BUILDNUM=$(date +%Y%m%d%H%M)
cd ..
/usr/bin/cp -rp avdworld.Stratis build/
cd build
find . -iname ".git*" -exec rm -rf "{}" \;
if [ ! $1 ]; then
	VERSION=$(cat ../VERSION)
else
	VERSION=$1
fi
echo "Starting building avd-world ${VERSION} build ${BUILDNUM}"
for i in $FORMAT_FILES; do
	sed "s/%VERSION%/${VERSION}/" $i > .tmp
	mv .tmp $i 
	sed "s/%BUILDNUM%/${BUILDNUM}/" $i > .tmp
	mv .tmp $i
done
cd ..
FILE="avdworld-${VERSION}.Stratis.pbo"
./ext/tools/cpbo/cpbo.exe -y -p build/ $FILE >> /dev/null

rm -rf build

echo $FILE created.
