#!/usr/bin/env bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

deactivate  > /dev/null 2>&1

if [ -d "venv" ]; then
  rm -rf venv
fi

python3 -m venv venv

. venv/bin/activate
pip3 install -r src/requirements.txt

PACKAGE_DIR=$(find ${PROJECT_ROOT}/venv -name "site-packages")
cd "${PACKAGE_DIR}"
zip -r "${PROJECT_ROOT}/app.zip" .

cd "${PROJECT_ROOT}/src"
zip -gr "${PROJECT_ROOT}/app.zip" .
