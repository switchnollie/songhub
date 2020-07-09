#!/bin/bash

for i in *.dart # or whatever other pattern...
do
  if ! grep -q Copyright $i
  then
    cat copyrightHeader.txt $i >$i.new && mv $i.new $i
  fi
done