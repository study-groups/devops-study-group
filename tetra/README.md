# Tetra Linux System Managment

## Features

- **User Management**: Automates user account operations and SSH key management.
- **Encryption**: Provides tools for secure data encryption and decryption.
- **Session Management**: Enhances terminal productivity with tmux script integrations.
- **Web Development**: Offers HTML and JavaScript snippets for quick web setup.
- **DevOps Tools**: Includes scripts for nginx, git, and logging configurations.

## Create Tetra environment

Begin with `source tetra/bash/init/create.sh` which will create the directory TETRA_DIR which is typically `$HOME/tetra` and contains `tetra.sh`, `tetra.env`  along with directories for storing SSH Keys, SSL certificates and API keys.

### Default $TETRA_DIR

```bash

$HOME/tetra/
├── env
│   ├── hosts.env -> ../orgs/orgname/hosts.env
│   └── ports.env -> ../orgs/orgname/ports.env
├── orgs
│   └── orgname
│       ├── hosts.env
│       └── ports.env
├── tetra.env
├── tetra.sh
├── users
│   └── username
│       ├── apis
│       │   └── OPENAI_API_KEY
│       └── keys
│           ├── id_rsa
│           ├── id_rsa.pem
│           └── id_rsa.pub
└── vault
```

### Default tetra.env

```bash
TETRA_USER=username
TETRA_ORG=orgname
TETRA_REMOTE=remotename.com
```

### Default tetra.sh

```bash
TETRA_DIR=$HOME/tetra
TETRA_SRC=$HOME/src/devops-study-group/tetra/bash
source $TETRA_DIR/tetra.env
source $TETRA_SRC/bootstrap.sh
```

## Environment variables

| Environment Variable | Value | Notes |
| --- | --- | --- |
| TETRA_SRC | $HOME/src/devops-study-group/tetra/bash | The source directory for the Tetra bash scripts. |
| TETRA_DIR | $HOME/tetra | The main Tetra directory. |
| TETRA_USER | default_user | The default user for Tetra. This can be changed to suit your needs. |
| TETRA_ORG | default_org | The default organization for Tetra. This can be changed to suit your needs. |
| TETRA_REMOTE |  | The remote server for Tetra. This field is empty by default and can be filled as needed. |

## Usage Convention

In your `.bashrc` file: `source $HOME/tetra/tetra.sh` 

After completing the bootstrap procedure, the terminal output will reflect the configured environment variables:

---

```
Standard Linux
  TETRA_SRC: $HOME/src/devops-study-group/tetra/bash
  TETRA_DIR: $HOME/tetra
  TETRA_USER: username
  TETRA_ORG: organme
  TETRA_REMOTE: remotename.com
  Tetra Bootstraping complete with linux-gnu.
```

# tetra_user

To create user `mr` on an machine at IP address $remote:
