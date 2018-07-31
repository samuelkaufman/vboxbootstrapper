export DEBIAN_FRONTEND=noninteractive

MYUSER=skaufman
export MYUSER=skaufman

echo <<EOS > /etc/network/interfaces.d/virtualbox-host-only
allow-hotplug enp0s8
iface enp0s8 inet dhcp
EOS

ifup enp0s8

apt-get update && apt-get install --no-install-recommends -y \
    wget \
    curl \
    locales \
    build-essential \
    cmake \
    ca-certificates \
    openssh-server \
    tmux \
    perl \
    perl-doc \
    vim-nox \
    git \
    file \
    less \
    rsync \
    sudo \
    unzip \
    ruby \
    pkg-config \
    automake \
    make \
    handbrake-cli \
    ntp \
    ntpdate \
    gnupg-agent \
    strace \
    ruby-dev \
    telnet \
    lsof \
    nginx \
    net-tools \
    redis-server \
    debconf-utils \
    openvpn \
    resolvconf \
    bind9 \
    bind9utils \
    dnsutils \
    cryptsetup \
    module-assistant \
    libssl-dev \
    libzip-dev \
    man-db \
    python-pip

export DEBIAN_FRONTEND=noninteractive

gem install sass ppjson

#get Go
cd /tmp
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xf go1.10.3.linux-amd64.tar.gz
mv go /opt/go-1.10.3

#get Node
wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.gz
tar -xf node-v8.11.3-linux-x64.tar.gz
mv node-v8.11.3-linux-x64 /opt/node-8.11.3

#get Perl
cd /opt
wget http://192.168.56.1:5000/perl-5.26.2.tar.gz
tar -xf perl-5.26.2.tar.gz
rm perl-5.26.2.tar.gz


#get Postgresql

mkdir -p /etc/apt/sources.list.d

#set up apt repo
echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update

apt-get install -y postgresql-10 postgresql-contrib libpq-dev


#host only networking

cat <<EOS > /etc/network/interfaces.d/virtualbox-host-only
allow-hotplug enp0s8
iface enp0s8 inet dhcp
EOS

service networking reload
ifup enp0s8


#add me to sudoers

usermod -a -G sudo $MYUSER

#turn off pw login for root
perl -p -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

cat <<'EOS' >> /etc/skel/.profile
export PATH=/opt/go-1.10.3/bin:$PATH
export PATH=/opt/node-8.11.3/bin:$PATH
export PATH=/opt/perl-5.26.2/bin:$PATH
EOS

cp /etc/skel/.profile /home/$MYUSER/.profile

##Set up google utils gsutil
# Create an environment variable for the correct distribution

# Add the Cloud SDK distribution URI as a package source
apt-get install --no-install-recommends -y lsb-release
echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update and install the Cloud SDK
apt-get update
apt-get install -y --no-install-recommends google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-go


##/End gsutil

##Update pip

pip install --upgrade pip virtualenv
