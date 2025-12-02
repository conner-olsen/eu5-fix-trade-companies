#!/usr/bin/env bash
set -e

rsync -av --inplace --no-times --exclude 'assets/' --exclude 'dist/' --exclude '.metadata/' --exclude '.git/' --exclude '.gitattributes' --exclude 'LICENSE' --exclude 'README.md' --exclude 'prepare-release.sh' ./ dist/

rm -rf ../fix-trade-companies
cp -r dist ../fix-trade-companies

find dist -mindepth 1 -maxdepth 1 ! -name '.metadata' -exec rm -rf {} +
