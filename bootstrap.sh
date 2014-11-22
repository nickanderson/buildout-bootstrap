#!/bin/bash


# buidout-bootstrap - how to bootstrap python buildout with virtualenv
# Copyright (C) 2014 Michael Rice <michael@riceclan.org>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

echo -n "Looking for bin directory... "
case "`basename $PWD`" in
    bin)
        echo "found (already here)"
        cd ..
        ;;
    *)
        echo -n "creating... " 
        mkdir bin
        echo "Done"
        ;;
esac
pwd
curl -O http://downloads.buildout.org/2/bootstrap.py

eggs="pip virtualenv"

echo "Automatic: setuptools, pip, virtualenv, buildout"
echo "Enter additional eggs>> "
read addeggs

eggs="$eggs $addeggs"

cat > buildout.cfg <<EOT
[buildout]
parts = $eggs
bin-directory = bin

EOT

for egg in ${=eggs}; do

cat >> buildout.cfg <<EOT
[$egg]
recipe = zc.recipe.egg
eggs = $egg

EOT

done

# First pass, get virtualenv installed so that we can use the local python
python bootstrap.py
bin/buildout
bin/virtualenv .
source bin/activate
# Second pass, rebuild using the local python
python bootstrap.py
bin/buildout