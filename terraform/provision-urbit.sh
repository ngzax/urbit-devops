# Make sure all our base packages are up-to-date
sum yum update -y

# Install all urbit dependencies
sudo yum --enablerepo epel install -y gcc gcc-c++ gmp-devel openssl-devel ncurses-devel libsigsegv-devel ctags automake autoconf libtool cmake re2c libcurl-devel

# Download build, and install the urbit source package
cd ~
mkdir source
cd source
wget https://media.urbit.org/dist/src/urbit-0.4.5.tar.gz
tar xfvz urbit-0.4.5.tar.gz
cd urbit-0.4.5
make
sudo install -m 0755 bin/urbit /usr/local/bin

# Add 2GB of swap so that we have enough memory to start up
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1
sudo echo "swap        /var/swap.1 swap    defaults        0   0" >> /etc/fstab

# Set up forwarding from port 80 (http) to 8080 and 443 (https) to 8443
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination :8080
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination :8443

# Other packages that are nice to have on the server
sudo yum install -y expect git tmux
