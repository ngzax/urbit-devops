# Make sure all our base packages are up-to-date
sudo apt update

# Install all urbit dependencies
#sudo apt install -y epel gcc gcc-c++ gmp-devel openssl-devel ncurses-devel libsigsegv-devel ctags automake autoconf libtool cmake re2c libcurl-devel
sudo apt install -y screen automake autoconf libtool cmake

# Download build, and install the urbit source package
cd ~
mkdir source
cd source
wget https://bootstrap.urbit.org/urbit-v0.10.8-linux64.tgz

tar xfvz urbit-v0.10.8-linux64.tgz
cd urbit-v0.10.8-linux64
#make
#sudo install -m 0755 urbit /usr/local/bin
mv urbit* ../../piers

# Add 2GB of swap so that we have enough memory to start up
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1

#ToDo: The following line does not seem to write to fstab. Also, the above does not persist after rebooting; test and fix this.
#sudo echo "swap        /var/swap.1 swap    defaults        0   0" >> /etc/fstab

# Set up forwarding from port 80 (http) to 8080 and 443 (https) to 8443
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination :8080
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination :8443

# Other packages that are nice to have on the server
sudo apt install -y expect git tmux
