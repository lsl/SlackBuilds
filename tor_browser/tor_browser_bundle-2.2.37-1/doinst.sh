( cd usr/sbin ; rm -rf tbb-user.sh )
( cd usr/bin ; rm -rf start-tor-browser )
if [ -e usr/lib64/tor_browser_bundle-2.2.37_1 ]; then
	( cd usr/sbin ; ln -sf ../lib64/tor_browser_bundle-2.2.37_1/tbb-user.sh tbb-user.sh )
	( cd usr/bin ; ln -sf ../lib64/tor_browser_bundle-2.2.37_1/start-tor-browser start-tor-browser )
else
	( cd usr/sbin ; ln -sf ../lib/tor_browser_bundle-2.2.37_1/tbb-user.sh tbb-user.sh )
	( cd usr/bin ; ln -sf ../lib/tor_browser_bundle-2.2.37_1/start-tor-browser start-tor-browser )
fi

if [ -e /etc/kde/kdm/Xstartup ]; then
	if ! grep -q tbb-user.sh /etc/kde/kdm/Xstartup; then
		echo "#tbb-user.sh start" >> /etc/kde/kdm/Xstartup 
		echo "if [ -x /usr/sbin/tbb-user.sh ]; then" >> /etc/kde/kdm/Xstartup 
    	echo "   /usr/sbin/tbb-user.sh $USER users" >> /etc/kde/kdm/Xstartup 
		echo "fi" >> /etc/kde/kdm/Xstartup 
		echo "#tbb-user.sh end" >> /etc/kde/kdm/Xstartup 
	fi
fi

