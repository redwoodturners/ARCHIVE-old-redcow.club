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

# Install bourbon
cd source && bundle exec bourbon install && cd ../

# clone gh-pages branch of site
git clone https://github.com/redwoodturners/www.redcow.club.git ../build

# build site
bundle exec middleman build
cp -R build ../ && cd ../build

# commit new site
git config user.email "rsuper@sonic.net"
git config user.name "sgoblin"
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
echo "starting push"
git push origin gh-pages && rm .git/credentials
