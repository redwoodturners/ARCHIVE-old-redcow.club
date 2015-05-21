#!/usr/bin/env sh
# Some of this is copyright @eshepelyuk from GitHub and can be found at https://eshepelyuk.github.io/2014/10/28/automate-github-pages-travisci.html
# The rest of this is copyright sgoblin with the Apache 2 license, which can be found at: http://www.apache.org/licenses/LICENSE-2.0

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site
bundle exec middleman build

# clone gh-pages branch of site
git clone https://${GH_TOKEN}@github.com/sgoblin/redcow.club.git
cd redcow.club
git checkout gh-pages

# copy new site into gh-pages branch
cp -R ../build/* ./

# commit new site
git config user.email "rsuper@sonic.net"
git config user.name "sgoblin"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
