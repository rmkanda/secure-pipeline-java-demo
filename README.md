# Setps to setup env for Demo

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
