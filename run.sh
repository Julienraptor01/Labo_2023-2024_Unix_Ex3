#!/bin/bash
mkdir -p ./out ./logs
if [ "$1" == "-c" ]
then
	rm -rf ./out/*
fi
rm -rf ./logs/*
unbuffer ./build/bin/main/Ex2 | tee ./logs/Ex2.log
