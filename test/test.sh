#!/bin/bash

errors=0
for suite in $(find $(dirname $0) -name '*_test.sh'); do
  $suite
  errors=$(( errors + $? ))
done
exit $errors
