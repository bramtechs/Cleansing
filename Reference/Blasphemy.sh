#!/bin/sh

set -xe

clang -std=c++17 -O3 -Wall -Wextra -fsanitize=memory -DBLASPHEMY -ggdb -x c++ -o Main Main.HC
