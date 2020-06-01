# Setps to setup

Sample sprint application with Jenkins pipeline script to demontrate secure pipelines

## Pre Requesites

- minikube

## Steps

- Setup minikube
  ```bash
  minikube start --memory 8000 --cpus=4
  ```
- Stup Jenkins server

  ```bash
  helm install jenkins stable/jenkins
  ```

  Note: make a note of the password

- Setup Dependency Track server

  ```bash
  helm repo add evryfs-oss https://evryfs.github.io/helm-charts/

  helm repo update

  kubectl create ns dependency-track

  helm install dependency-track evryfs-oss/dependency-track --namespace dependency-track
  ```

  Note: dependency-track will take some time to start

- Create a new Jenkins pipeline with this repo and trigger build

# Pipeline

Refer the below screenshot for the stages in the pipeline

![Pipeline View](imgs/Secure_Pipeline_2.png)

![Stage View](imgs/Secure_Pipeline_1.png)

![Dependency Track View](imgs/Dependency_Track.png)
