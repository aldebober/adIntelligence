# adIntelligence
test task

### Development Toolchain
Component | Software | Version | Notes
--------- | -------- | ------- |------
Helm	 |	| 3.1.2	| Installation method: brew
Docker to build image | | 19.03.5|
Infrastructure is deployed with Terraform | Terraform | v0.11.14 |

## Process
### There are two Terraform subdirectories: 
- cluster 
- helm

### helm chart and docker image subdirectories: 
- hello-world
- Docker

### Infrastructure
Go to cluser
Edit terraform.tfvars and apply. It creates k8s service in DO
Next step is creating helm releases from helm directory. It's responsable for:
- Ingress-nginx
- Prometheus-operator

