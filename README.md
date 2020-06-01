# Secure Pipelines

Sample spring application with Jenkins pipeline script to demontrate secure pipelines

# Setps to setup

## Pre Requesites

- minikube - [Refer here for installation](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- helm - [Refer here for installation](https://helm.sh/docs/intro/install/)

## Steps

- Setup minikube
  ```bash
  minikube start --memory 8000 --cpus=4
  ```
- Stup Jenkins server

  ```bash
  helm install jenkins stable/jenkins
  ```

  **Note:** make a note of the password

- Add additonal plugins to Jeninks server (Manage Jenkins -> Manage plugins)

  - BlueOcean
  - Configuration as a code
  - Dependency Track

- Setup Dependency Track server

  ```bash
  helm repo add evryfs-oss https://evryfs.github.io/helm-charts/

  helm repo update

  kubectl create ns dependency-track

  helm install dependency-track evryfs-oss/dependency-track --namespace dependency-track
  ```

  **Note:** dependency-track will take some time to start (~1hr on low end mac)

- Create a new Jenkins pipeline with this repo and trigger build

# Pipeline

Refer the below screenshot for the stages in the pipeline

##### Pipeline View

![Pipeline View](imgs/Secure_Pipeline_1.png)

##### Stage View

![Stage View](imgs/Secure_Pipeline_2.png)

##### Dependency Track

![Dependency Track View](imgs/Dependency_Track.png)
