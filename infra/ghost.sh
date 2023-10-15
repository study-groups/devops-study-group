if [[ -z "$GHOST_HOST" || \
     -z "$GHOST_DEBUG_PORT" || \
     -z "$GHOST_DEV_PORT"  ]]; then
  echo ""
  echo "  NOT ALL ENV SET"
  echo ""
fi

echo "Using GHOST_HOST=$GHOST_HOST"
echo "Using GHOST_DEV_PORT=$GHOST_DEV_PORT"
echo "Using GHOST_DEBUG_PORT=$GHOST_DEBUG_PORT"

ghost=$GHOST_HOST        # semi-semantic (infra_detail)  to semantic (ghost)

ghost-login(){
  ssh root@$ghost
}

ghost-mount-prepare-mac(){
  #ln -s $HOME/mnt/ghost /var/www/ghost
  sudo ln -s /private/var/www/ghost /var/www/ghost
  #mkdir /var/www/ghost
}


ghost-mount(){
  #sshfs root@$ghost:/ $HOME/mnt/ghost
  #sshfs root@$ghost:/var/www/ghost $HOME/mnt/ghost
  sudo sshfs root@$ghost:/var/www/ghost /var/www/ghost \
   -oauto_cache,reconnect,defer_permissions, \
   negative_vncache,allow_other,\
   volname=GhostWest
}

ghost-unmount(){
  sudo umount /var/www/ghost
}

ghost-dev(){
  cd /var/www/ghost
  NODE_ENV=development \
  NODE_OPTIONS="--tls-keylog=tls.log \
    --inspect=127.0.0.1:$GHOST_DEBUG_PORT" \
  node current/index.js
}

ghost-tunnel(){
  ssh -nNT -L \
    $GHOST_DEV_PORT:127.0.0.1:$GHOST_DEV_PORT \
    root@$ghost
}

ghost-tunnel-debug(){
  ssh -nNT -L \
    $GHOST_DEBUG_PORT:127.0.0.1:$GHOST_DEBUG_PORT \
    root@$ghost
}

ghost-clone-db(){
  mysqldump -u root ghost_prod > ghost_dev.sql
  mysql -u root ghost_dev < ghost_dev.sql

}

ghost-dev-nuke-brute(){
  echo " Truncate the brute table to reset magic link email lockout."
  mysql -e "TRUNCATE TABLE ghost_dev.brute;"
}

ghost-copy-content(){
  sudo cp -r /var/www/ghost/content /var/www/ghost/content_dev
  sudo chown -R  ghost:ghost /var/www/ghost/content_dev
}

ghost-local-init(){
  ghost-tunnel & 
  ghost-tunnel-debug &
  cat <<EOF

Node server running debugger via env vars used by $> ghost run

Application on $GHOST_DEV_PORT which is also set in

config.developmennt.json

Debugger on $GHOST_DEBUG_PORT

Use chrome://inspect and select localhost:$GHOST_DEBUG_PORT
to start debugging.

EOF

}
ghost-local-list(){
 ps | grep localhost 
}
ghost-local-kill(){
 ps | grep localhost | awk '{print $1}' | xargs kill
}