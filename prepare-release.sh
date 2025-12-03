#!/usr/bin/env bash
set -e

rsync -av --inplace --no-times in_game/ main_menu/ dist/

rm -rf ../fix-trade-companies
cp -r dist ../fix-trade-companies

find dist -mindepth 1 -maxdepth 1 ! -name '.metadata' -exec rm -rf {} +
