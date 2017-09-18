1. Figure out what to do as bower, npm, and gulp did not make it to the strech
   repos. Perhaps they'll find their way into stretch-backports later on.
2. Find a better solution for check_installed. The current one makes typos hard
   to catch.
3. Stop piping to >/dev/null, it's hiding bugs from view.
