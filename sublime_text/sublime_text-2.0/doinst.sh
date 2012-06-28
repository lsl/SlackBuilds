( cd usr/bin ; rm -rf sublime_text )
if [ -e usr/lib64/sublime_text-2.0 ]; then
  ( cd usr/bin ; ln -sf ../lib64/sublime_text-2.0/sublime_text sublime_text )
else
  ( cd usr/bin ; ln -sf ../lib/sublime_text-2.0/sublime_text sublime_text )
fi