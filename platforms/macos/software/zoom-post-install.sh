#!/bin/sh

# Placeholder post-install script for Zoom.
#
# Fleet runs this as root right after Zoom installs. It doesn't
# change anything yet: it just prints a friendly fox to the install
# output in Fleet. Replace the body with real post-install steps
# (e.g. setting defaults) when you have some.

cat <<'EOF'

   /\   /\
  //\\_//\\     ____
  \_     _/    /   /
   / * * \    /^^^]
   \_\O/_/    [   ]
    /   \_    [   /
    \     \_  /  /
     [ [ /  \/ _/
    _[ [ \  /_/

  Zoom is installed. What does the fox say? "Join meeting."

EOF

exit 0
