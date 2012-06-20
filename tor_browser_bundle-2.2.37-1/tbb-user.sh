    #!/bin/bash
    #Name    : tbb-user.sh
    #version : 0.5
    #Author  : Luke Williams
    #Email   : xocel@iquidus.org
    #Date    : 2012/05/20
    #Purpose : Configures Tor Browser Bundle to run as the specified user when ownership belongs to root.
    #Platform: Linux 
    #Notes   : Script must be placed in TBB root dir (same dir as start-tor-browser)
    #          Written for TBB 2.2.37-1

    function usage {
        # Outputs usage
        echo "Usage: `basename $0` <options>"
        echo " "
        echo "Options:"
        echo "   username groupname , Configures TBB to be run by the specified user"
        echo "                        by creating required files in ~/.TBB with ownership"
        echo "                        belonging to username.groupname"
        echo "   --restore          , Removes all files created by `basename $0`" 
        echo "                        from the system and restores TBB to its"
        echo "                        orignal state."
        echo "   --help             , Display this message."
        echo " "
        exit 1
    }

    #Make sure script is being run as root.
    if [ "`id -u`" -ne 0 ]; then
        echo "This script needs to be run as root"
        exit 1
    fi

    #Check if script is being run through a symlink.
    MYNAME="$0"
    if [ -L "$MYNAME" ]; then
        MYNAME="`readlink -f "$MYNAME" 2>/dev/null`"
        if [ "$?" -ne 0 ]; then
            # Ugh.
            echo "`basename $0` cannot be run using a symlink on this operating system."
        fi
    fi

    #make sure we are in the right dir.
    CWD="`dirname "$MYNAME"`"
    test -d "$CWD" && cd "$CWD"

    EXPTD_ARGS=2
    ORIG="$CWD/Data.bak"

    #Check args.
    if [ $# -ne $EXPTD_ARGS ]; then
        if [ $# -eq 1 ]; then
            if [ $1 == "--restore" ]; then
		        echo "Removing TBB files from home directories"
                rm -rfv /home/*/.TBB
		        echo "Removing symlinks"
                rm -rvf "$CWD/.config"
                rm -rvf "$CWD/.kde"
                rm -rvf "$CWD/.mozilla"
                rm -rvf "$CWD/.nv"
		        echo "Restoring Data directory"
                if [ -e $ORIG ]; then
                    rm -v  "$CWD/Data"
                    mv -v $ORIG "$CWD/Data"
                fi
		        echo "All operations have completed successfully"
		        exit 1
            else
                usage
            fi
        else
            usage
        fi
    fi

    #Script has made it this far, assume a user is to be configured.   
    #Set variables
    USERNAME=$1
    GROUP=$2
    TBB="/home/$USERNAME/.TBB"

    #Check if user exists
    USER_EXISTS=$(grep -c ^$USERNAME: /etc/passwd)
    if [ $USER_EXISTS -ne "1" ]; then
        echo "$USERNAME: Invalid username"
        exit 1
    fi

    #Check user belongs to group
    IN_GROUP=0 #1 if user belongs to group, otherwise 0.
    USER_GROUPS=$(echo $(groups $USERNAME) | tr " " "\n")
    for g in $USER_GROUPS
    do
        if [ $g == $GROUP ]
        then
            IN_GROUP=1
        fi
    done

    if [ $IN_GROUP -ne 1 ]; then
        echo "$USERNAME does not belong to group: $GROUP"
        exit 1
    fi

    #check to see if script has been run before.
    #If not, rename Data dir.
    if [ ! -d $ORIG ]; then
        mv "$CWD/Data" $ORIG
    fi
     
    #check to see if .TBB exists in specified users home dir.
    #If not, create ~/.TBB, copy Data dir into it and create conf dirs.  
    if [ -d $TBB ]; then
        echo "$TBB already exists"
    else
        mkdir $TBB
        cp -R $ORIG "$TBB/Data"
        mkdir "$TBB/.config"
        mkdir "$TBB/.kde"
        mkdir "$TBB/.mozilla"
        mkdir "$TBB/.nv"
        chown -R $USERNAME.$GROUP $TBB
    fi
    #check if symlinks exist, if so remove them.
    if [ -e "$CWD/Data" ]; then
        rm "$CWD/Data"
        rm "$CWD/.config"
        rm "$CWD/.kde"
        rm "$CWD/.mozilla"
        rm "$CWD/.nv"
    fi
    
    #create new symlinks.
    ln -s "$TBB/Data" ./
    ln -s "$TBB/.kde" ./
    ln -s "$TBB/.config" ./
    ln -s "$TBB/.mozilla" ./
    ln -s "$TBB/.nv" ./

    #Configuration complete.
    echo "Tor Browser Bundle is now configured to be run by $USERNAME"
