#!/bin/bash

#当前脚本目录
CURRENT_DIR=$(cd `dirname $0`; pwd)
echo $CURRENT_DIR

PROJECT_FILE=$(ls | grep podspec | awk -F.podspec '{print $1}')

echo Start validate ${PROJECT_FILE}.podspec ....

touch .swift-version
echo "3.0" > .swift-version

pod lib lint  ${CURRENT_DIR}/${PROJECT_FILE}.podspec --verbose --sources=https://github.com/CocoaPods/Specs.git --allow-warnings --use-libraries


