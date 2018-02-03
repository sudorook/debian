1. Figure out what to do as bower, npm, and gulp did not make it to the strech
   repos. Perhaps they'll find their way into stretch-backports later on.
2. Find a better solution for check\_installed. The current one makes typos
   hard to catch.
3. Stop piping to \>/dev/null, it's hiding bugs from view.
4. "Upgrade Debian release" terminates the script when the greps of the srclist
   return false.
5. show\_info prints grey text against white backgrounds (light theme).
6. Cannot install nodejs-legacy on sid because it doesn't exist in the repos.
   Attempts to install result in a message that the nodejs dependency is not
   fulfilled. Removing nodejs-legacy fixes the issue in sid.
