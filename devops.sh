dotool-help(){
  echo "
  dotool version 18.12

  dotool is as collection os Bash functions making 
  Digital Ocean's command line doctl tool easier to use.

  Digital Ocean API key goes here:
       ~/snap/doctl/current/.config/doctl/config.yml

  See Digital Ocean's doctl documentation here:

  https://www.digitalocean.com/community/tutorials/
  how-to-use-doctl-the-official-digitalocean-command-line-client
  "
}

dotool-info(){
  echo "API key stored in .config/doctl/config.yaml"
  doctl account get
}

dotool-keys(){
  doctl compute ssh-key list
}

dotool-list(){
  doctl compute droplet list \
      --format "ID,Name,PublicIPv4,Volumes"
}
dotool-list-long(){
  doctl compute droplet list \
      --format "ID,Name,Memory,Disk,Region,Features,Volumes"
}


#--image ubuntu-18-04-x64 \
#38835928
dotool-create(){
  imgtype=${3:-ubuntu-18-04-x64}
  echo "Using $imgtype"
  doctl compute droplet create $1 \
        --size 1gb  \
        --image $imgtype \
        --region sfo2 \
        --ssh-keys $2
}


dotool-delete(){
  doctl compute droplet delete $1
}

dotool-id-to-ip(){
  local id=$1
  doctl compute droplet get $id \
      --no-header \
      --format "Public IPv4"
}

dotool-name-to-ip(){
  local id=$(dotool-list | grep "$1 " | awk '{print $1}')
  echo $(dotool-id-to-ip $id)
}

dotool-login(){
  ssh root@$(dotool-name-to-ip $1)
}

dotool-cp(){
  scp $1 root@$(dotool-name-to-ip $2):$3
}

dotool-config(){
  CONFIG=${2:-config.sh}    
  dotool-cp $CONFIG $1 $CONFIG # $2=config-file $1=droplet-name
  ssh root@$(dotool-name-to-ip $1) '\
      #source $CONFIG
      #config-init
      echo "Log in to remote host"
      echo "---------------------"
      echo "local> dotool login <droplet>"
      echo "remote> source config.sh"
      echo "remote> config-init"
'
}

dotool-status(){
  ssh root@$(dotool-name-to-ip $1) '\
  echo ""
  echo "vm stat -s"
  echo "----------"
  vmstat -s
  echo ""
  df
'
}

dotool-upgrade(){
  ssh root@$(dotool-name-to-ip $1) "\
      apt -y update
      apt -y upgrade
"
}
dotool-possibilites(){
  echo ""
  echo "All private and public images available to clone"
  echo "------------------------------------------------"
  doctl compute image list --public --format "ID,Name"
  echo ""
  echo "All available locations"
  echo "-----------------------"
  doctl compute region list
}

dotool-remote-daemonize () {
    local remoteIp=$(nhctl-droplet-name-to-ip $1 );
    echo "Here is the $remoteIp";
    local remotePath="/root/";
    scp "/home/cqc/src/vendor/daemonize/daemonize" root@$remoteIp:
}
dotool-remote-provision() {
    local remoteIp=$(dotool-droplet-name-to-ip $1 );
    local remotePath="/root";
    local gitCqcServer="https://github.com/code-quality-consulting/cqc-server.git";
    ssh -t root@$remoteIp git clone $gitCqcServer
}

dotool-remote-init() {
    local remoteIp=$(dotool-name-to-ip $1 );
    ssh root@$remoteIp bash /root/cqc-server/cqc-init.sh
}

dotool-remote-whoami() {
    ssh root@$remote docker-compose -f /root/cqc-server/docker-compose.yml up -d whoami
}

enctool-cert()
{
    certbot certonly --manual \
        --preferred-challenges=dns-01 \
        --agree-tos -d *.$1 # pass domainname.com

}

rctool-help() {
    echo "rctool is  collection of Bash scripts which makes interfacing
to Reseller Club's Domain Name Management API easier. More API info:

https://manage.resellerclub.com/kb/node/1106

You are using RC_APIKEY = $RC_APIKEY
"
}

rctool-init(){
    # RCTOOL_PATH must be set prior to calling
    RCTOOL_PATH=.
    source $RCTOOL_PATH/resellerclub/env.sh
}

rctool-list-a() {
    # https://manage.resellerclub.com/kb/node/1106
    http "https://test.httpapi.com/api/dns/manage/search-records.json?auth-userid=$RC_USERID&api-key=$RC_APIKEY&domain-name=$1&type=A&no-of-records=50&page-no=1"
}

rctool-list-txt() {
    http "https://test.httpapi.com/api/dns/manage/search-records.json?auth-userid=$RC_USERID&api-key=$RC_APIKEY&domain-name=$1&type=TXT&no-of-records=50&page-no=1"
}

rctool-add-txt() {
    http "https://test.httpapi.com/api/dns/manage/add-txt-record.json?auth-userid=$RC_USERID&api-key=$RC_APIKEY&host=$RC_HOST&domain-name=$1&value=$2"
}

rctool-update-txt() {
    http "https://test.httpapi.com/api/dns/manage/update-txt-record.json?auth-userid=$RC_USERID&api-key=$RC_APIKEY&host=$RC_HOST&domain-name=$1&value=$2"
}


rctool-delete-txt() {
    http "https://test.httpapi.com/api/dns/manage/delete-txt-record.json?auth-userid=$RC_USERID&api-key=$RC_APIKEY&host=$RC_HOST&domain-name=$1&value=$2"
}