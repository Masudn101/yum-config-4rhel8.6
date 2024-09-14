hostnamectl set-hostname server1.abc.com
echo "192.168.8.10 server1.abc.com server1" >> /etc/hosts
echo "192.168.8.20 server2.abc.com server2" >> /etc/hosts
echo "192.168.8.30 server3.abc.com server3" >> /etc/hosts
echo "192.168.8.1 host11" >> /etc/hosts
echo "192.168.8.2 gateway" >> /etc/hosts

nmcli connection delete ens160 
nmcli connection add autoconnect yes con-name profile1 ifname ens160 type ethernet
nmcli connection modify profile1 ipv4.addresses 192.168.8.10/24
nmcli connection modify profile1 ipv4.gateway 192.168.8.2
nmcli connection modify profile1 ipv4.method manual 
nmcli connection modify profile1 ipv4.dns 192.168.8.10
nmcli connection modify profile1 +ipv4.dns 192.168.8.20
nmcli connection modify profile1 +ipv4.dns 192.168.8.30
nmcli connection modify profile1 +ipv4.dns 8.8.8.8
nmcli connection modify profile1 ipv4.dns-search abc.com
nmcli connection up profile1 

rm -rfv /etc/yum.repos.d/* #for rhel8.6.0

cat <<EOF>> /etc/yum.repos.d/AmarRepo.repo
[AppStream]
name=Amar Nijer AppStream
baseurl=file:///run/media/root/RHEL-8-6-0-BaseOS-x86_64/AppStream/
enabled=1
gpgcheck=0

[BaseOS]
name=Amar Nijer BaseOS
baseurl=file:///run/media/root/RHEL-8-6-0-BaseOS-x86_64/BaseOS/
enabled=1
gpgcheck=0
EOF

yum clean all
yum repolist 
yum list available 
yum remove tree -y
yum install tree -y

ip addr show ens160

hostnamectl

ping server1.abc.com -c5
