( cd usr/bin ; rm -rf sublime_text )
if [ -e usr/lib64/sublime_text-2_2181 ]; then
  ( cd usr/bin ; ln -sf ../lib64/sublime_text-2_2181/sublime_text sublime_text )
else
  ( cd usr/bin ; ln -sf ../lib/sublime_text-2_2181/sublime_text sublime_text )
fi