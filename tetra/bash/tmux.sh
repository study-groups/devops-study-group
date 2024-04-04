tetra-tmux-new(){
  local sessionName="${1:-"untitled-session"}
  local scriptName="${2:-"/dev/null"}
  tmux new-session -d -s "$sessionName" "$scriptName"
}

tetra-tmux-list(){
  tmux list-sessions # aka tmux ls
}

tetra-tmux-join () 
{   
    tmux has-session -t tetra 2>/dev/null &&  \
    tmux attach-session -t $1 || \
    tmux new-session -s $1
}

tetra-tmux-kill-session(){
  tmux kill-session -t $1
}

tetra-tmux-kill-server(){
  echo "Will kill everything tmux."
  tmux list-sessions
  read -p "Sure? ctrl-c to exit."
  tmux kill-server
}

