#!/bin/sh

# https://sourceforge.net/p/lufs/svn/HEAD/tree/trunk/lufs2/lufsd/lussh



echo
echo This script will help you setup ssh public key authentication.



host=dummy
    
while [ -n "$host" ]; do 
echo -n "SSH server: "
read host
if [ -n "$host" ]; then
    echo -n "user[$USER]: "
    read usr
    if [ -z "$usr" ]; then
	usr=$USER
    fi
	    
    echo "Setting up RSA authentication for ${usr}@${host}..."	    
    if [ -f ~/.ssh/id_rsa.pub ]; then 
	echo "RSA public key OK." 
    else 
	ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
    fi
    scp ~/.ssh/id_rsa.pub ${usr}@${host}:~/
    ssh ${usr}@${host} "if [ ! -d ~/.ssh ]; then
    				mkdir ~/.ssh
			    fi
			    cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
			    chmod 0600 ~/.ssh/authorized_keys
			    rm ~/id_rsa.pub" 
    echo
    echo "You should see the following message without being prompted for anything now..."
    echo
    ssh ${usr}@${host} "echo !!! Congratulations, you are now logged in as ${usr}@${host} !!!"
    echo
    echo "If you were prompted, public key authentication could not be configured..."
				
	    echo
	    echo "Enter a blank servername when done."	    
	    echo
fi	
done

echo "End of configuration."
