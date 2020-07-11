# File starts below.
####################################################################
# Source these functions as admin. 

admin-help(){
  echo "\
   Admin is a collection of scripts to configure runtime operations.

   Securely copy the admin.sh file to your new remote machine: 
    1) scp admin.sh ssh admin@host:admin.sh

   Source admin.sh on remote using ssh and call admin-init function:
   2) ssh admin@host: \"source admin.sh && admin-init\"

  Requires:
    - running as admin

  Configures a Unix server and account for process 'containers'
  addresseble by system defined TCP sockets. 
"
}

# belongs to mother
nodeholder-copy-file() {
  #local ip_addr=$(dotool-name-to-ip "$1");
  local ip_addr=$1;
  local admin_file="$2";
  scp "$admin_file" admin@"$ip_addr":"$admin_file"
}


### Zach's interpretation ###

admin-create-paths() {

  # make room for repos and app deployment.
  mkdir /home/admin/src/   # where apps are developed
  #mkdir /home/admin/apps/  # where apps are deployed to production
  #echo "development and production setup finished"

}

admin-clone-app() {
  # enters development directory
  cd /home/admin/src/

  local repo_url=$1;
  local basename=$(basename $repo_url); # myapp.git
  local app_name=${basename%.*}; # myapp  (removes .git)
  git clone $repo_url

  #local app_dir_path="/home/admin/src/$app_name/";

  # path to use when serving application
  # production_path=$2; # e.g. bin or index.js
  # echo "production path is: $production_path"
 
  # copy development to production 
  #cp -r /home/admin/src/$app_name $app_dir_path

  # set pwd to home for next function call
  #cd /home/admin

}

admin-daemonize-app() {

  # current working directory
  local cwd=$1;

  # command to run program
  local cmd=$2;

  # path to file
  local args=$3;
  
  echo "cwd: $cwd\n cmd: $cmd\n args: $args"
  
  # daemonize application running as admin
  daemonize \
	  -E PORT=4444 \
	  -c $cwd \
	  -p $cwd/app.pid \
	  -e $cwd/app.err \
	  -o $cwd/app.log \
	  "$cmd" "$args"
}

zach-admin-init() {
  local app_name="node-hello-world"
  local app_repo="https://github.com/zoverlvx/$app_name.git"
  admin-create-paths  # creates /home/admin/{src,apps}
  admin-clone-app $app_repo

  # configure and daemonize PRODUCTION
  #local cmd="/usr/bin/node"
  #local cwd="/home/admin/src/node-hello-world/production/"
  #local app_path="$cwd/in/www.js"

  # configure and daemonize DEVELOPMENT
  app-build
  app-start
  #local cmd="/usr/bin/node"
  #local cwd="/home/admin/src/node-hello-world/nodeholder/development"
  #local app_entry="www.js"
  #local args="$cwd/$app_entry $PORT"
  #admin-daemonize-app $cwd $cmd $args    # imperative  
  #admin-daemonize-app $cwd $cmd $app_entry   # declarative
}

####End of Zach's interpretation #####

admin-install-sae(){
  # presume src directory exists
  cd /home/admin/src/

  local app_name=sentiment-analysis-engine
  local repo_url="https://gitlab.com/zoverlvx/$app_name.git";
  git clone $repo_url

  # presumes repo contains a directory called app that can be
  # served from this system.
  local app_dir="/home/admin/apps/$app_name"    # production app
  mkdir $app_dir
  cp -r /home/admin/src/$app_name/bin $app_dir  # change to match repo

  # set pwd to home for next function call
  cd /home/admin
}


admin-install-apps(){

  # make room for repos and app deployment.
  mkdir /home/admin/src/   # where apps are developed
  mkdir /home/admin/apps/  # where apps are deployed to production 

  admin-install-sae
}

admin-start-apps(){
# Start node servers (ports are currently defined by user, later system)

    # Future: loop over directories in  /home/admin/apps and call init.sh

    node /home/admin/apps/sentiment-analysis-engine/bin/www.js
}

# This local functions will be called. Comment out as needed.
admin-init(){
  zach-admin-init
  #admin-install-apps
  #admin-start-apps
}

userdir="/home/admin"
pidfile="$userdir/src/node-hello-world/nodeholder/development/app.pid"
stopfile="$userdir/src/node-hello-world/nodeholder/development/stop.sh"
startfile="$userdir/src/node-hello-world/nodeholder/development/start.sh"
statusfile="$userdir/src/node-hello-world/nodeholder/development/status.sh"
admin-uninit(){
  admin-app-kill
  rm -rf $userdir/src
}

admin-app-kill(){
  local pid=$(admin-get-pid)
  local time=$(date)
  >&2 echo "$time: Killing $pid" 
  kill $pid
  time=$(date)
  >&2 echo "$time: Killed: $pid" 
  echo "" > $pidfile
}


admin-get-pid(){
  local pid=$(cat $pidfile);
  echo $pid 
}

admin-app-status(){
  echo using PID file:  $pidfile
  echo Using status file:  $statusfile
}
