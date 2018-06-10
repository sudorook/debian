1. Figure out what to do as bower, npm, and gulp did not make it to the stretch
   repos. Perhaps they'll find their way into stretch-backports later on.
2. Find a better solution for check\_installed. The current one makes typos
   hard to catch.
3. Stop piping to \>/dev/null, it's hiding bugs from view.
4. Cannot install nodejs-legacy on sid or buster because it doesn't exist in
   the repos. Attempts to install result in a message that the nodejs
   dependency is not fulfilled.
5. Beets depends on python2 in stretch but python3 in buster. For now, just
   install both versions of the libraries needed by beets plugins.
