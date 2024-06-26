# devops-study-group
Notes on provisioning, securing and
maintaing cloud based resources at Digital Ocean, Google and AWS.

- [dotool.sh](./dotool.sh): Bash functions for createing resources in the Digital Ocean ecosystem.

- [nodeholder.sh](./investigations/nodeholder/): Bash functions for creating users and installing applications.

- [tetra.sh.enc](./tetra/): personalized Bash functions for securely managing microservices. 

The [12 Factors App](https://12factor.net/) by the Heroku team is a 
guiding philosophy.


## Virtual Environments
Two methods of virtualization:

1. [hypervisor](https://en.wikipedia.org/wiki/Hypervisor) for virtual private servers.
2. [container](https://en.wikipedia.org/wiki/OS-level_virtualization) for containers based off of [LXD / LXC](https://linuxcontainers.org/lxd/introduction/), e.g. [Docker](https://www.devonblog.com/continuous-delivery/lxc-vs-lxd-vs-docker-evolution-of-the-container-ecosystem/).

. | Hypervisor | Container
--- | --- | ---
**Google** | [KVM](https://cloud.google.com/blog/products/gcp/7-ways-we-harden-our-kvm-hypervisor-at-google-cloud-security-in-plaintext) | [Containers](https://cloud.google.com/containers/)
**DigitalOcean** | [Droplets](https://www.digitalocean.com/docs/) | [Kubernetes](https://www.digitalocean.com/products/kubernetes)
**AWS** | [EC2](https://aws.amazon.com/ec2/instance-types/) | [Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html)



## Google Cloud Platform v. Digital Ocean v. AWS

GCP | Digtal Ocean | AWS
--- | --- | ---
[Devops Philosophy](https://cloud.google.com/devops/) | [CI/CD](https://www.digitalocean.com/community/tags/ci-cd) | [AWS-CICD](https://aws.amazon.com/blogs/devops/complete-ci-cd-with-aws-codecommit-aws-codebuild-aws-codedeploy-and-aws-codepipeline/)
compute | [droplet](https://www.digitalocean.com/products/droplets) | [EC2](https://aws.amazon.com/ec2/instance-types/)
bucket | [spaces](https://www.digitalocean.com/products/spaces/) | [S3/EBS](https://aws.amazon.com/ebs/)
images |  [images](https://www.digitalocean.com/docs/images/) | [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
volumes | [block storage](https://www.digitalocean.com/products/block-storage/) | [EFS](https://aws.amazon.com/efs/)
[snapshots](https://cloud.google.com/compute/docs/disks/create-snapshots) | [snapshots](https://www.digitalocean.com/docs/images/snapshots/) | [EBS Snapshot](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html)
[network](https://cloud.google.com/blog/products/networking/google-cloud-networking-in-depth-how-andromeda-2-2-enables-high-throughput-vms) | [virtual-network](https://www.digitalocean.com/products/networking/) | [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html)
availability | [availability](https://www.digitalocean.com/docs/platform/availability-matrix/) | [Regions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

## HashiCorp

Hashicorp was founded by Mitchell Hashimoto, the creator of [Vagrant](https://www.youtube.com/watch?v=UTQQggVx4sI) which 
shows basic usage with Puppet in 2012. Now HashiCorp's products do the automation and Puppet, Chef and Ansible are not necessary:

1. [Terraform](https://www.hashicorp.com/products/terraform): Infrastructure as code for provisioning, compliance, and management of any cloud, infrastructure, and service.
2. [Vault](https://www.hashicorp.com/products/vault/): Secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.
3. [Consul](https://www.hashicorp.com/products/consul/): A multi-cloud service networking platform to connect and secure services across any runtime platform and public or private cloud.
4. [Nomad](https://www.hashicorp.com/products/nomad/): Deploy and Manage Any Containerized, Legacy, or Batch Application.
Nomad is an easy-to-use, flexible, and performant workload orchestrator that enables organizations to deploy applications on any infrastructure at scale.

Hashicorp | tetra.sh
--- | ---
terraform | tetra-create-vm-{digocean,google}
vault | tetra-keys-add-{digocean,google}
consul | tetra-{start,stop,update}
nomad | tetra-run

## Service Mesh

- [certbot for TLS](https://certbot.eff.org/): Instructions for [certbot on 20.04](https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal).
- [acme.sh](https://github.com/acmesh-official/acme.sh): pure Bash alternative to certbot.
- [Nginx docs](https://docs.nginx.com/) handles reverse-proxy and SSL certificates. A reverse-proxy maps an HTTP/S url with a domainanme, to a new domainame and port number.

## Docker
### Foundation
- [Why Docker?](https://www.docker.com/why-docker) and [What is a container at docker.com](https://www.docker.com/resources/what-container)
- [Get started](https://docs.docker.com/get-started/) Dockerfile: [Dockerfile at Docker](https://docs.docker.com/glossary/?term=Dockerfile) and [best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Glossary](https://docs.docker.com/glossary/): worth a read, especially for layers and overlays.

### Storage
- [Docs on Volumes](https://docs.docker.com/storage/volumes/) the preferred mechanism for data persistence
- [Doc on services](https://docs.docker.com/get-started/part3/#about-services) Services are really just “containers in production.”
- [Compose files](https://docs.docker.com/compose/compose-file/): Run, and scale services with the Docker platform via [docker-compose.yml](https://docs.docker.com/get-started/part3/#your-first-docker-composeyml-file)

### Network
- [Overlay](https://docs.docker.com/network/overlay/) network [driver (bridge, host, overlay, 3rd-party)] (https://docs.docker.com/network/#network-drivers) creates a distributed network among multiple Docker daemon hosts. 
- Networking: [Docker container networking](https://docs.docker.com/v17.09/engine/userguide/networking/#default-networks)

### Security
- There are four major areas to consider when reviewing [Docker security](https://docs.docker.com/engine/security/security/).

## References
- [remote procedure calls](https://en.wikipedia.org/wiki/Remote_procedure_call)
(as opposed to REST or GraphQL requests).
- [One click digitalocean.com](https://docs.digitalocean.com/products/marketplace/catalog/docker/#getting-started-after-deploying-docker): notice IP table considerations since [Docker manipulates iptable rules](https://docs.docker.com/network/iptables/) to provide network isolation
- [Docker Engine Faq](https://docs.docker.com/engine/faq/): Docker frequently asked questions, 9 min read.
- [Docker Crib Sheet](https://github.com/wsargent/docker-cheat-sheet)
 - [ICANN - Internet Corporation for Assigned Names and Numbers](https://www.icann.org/resources/pages/beginners-guides-2012-03-06-en) This is where domain names come from.
- [git](https://git-scm.com/): Git is version control for software development, written by Linus Torvalds.
- [Git From the Bits Up](https://www.youtube.com/watch?v=MYP56QJpDr4): Join GitHub trainer and evangelist Tim Berglund for more advanced look at "weird internals stuff" and obscure commands.

- [Git Tutorial for Beginners: Command-Line Fundamentals](https://www.youtube.com/watch?v=HVsySz-h9r4&list=PL-osiE80TeTuRUfjRe54Eea17-YfnOOAx): Videos by Corey Schafer.
