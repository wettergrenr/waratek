Not using bash getopts due to:
"Note that getopts is not able to parse GNU-style long options (--myoption) or XF86-style long options (-myoption)!"
(From: http://wiki.bash-hackers.org/howto/getopts_tutorial)

"The user must be able to compile either all source under <root>/src or alternatively just one of the two components."
Test jar dependency on main jar requires it to be built.
Option added to omit test classes using test.skip property.

Enhancements:
1. Added ant "clean" target to simplify automation.
2. Added manifest containing build user and version for jar identification.

