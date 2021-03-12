# Installation Steps for Dependency Track

- Setup helm repo

  ```s
  helm repo add evryfs-oss https://evryfs.github.io/helm-charts/

  helm repo update
  ```

- Create a file with below contents - values.yaml

  ```yaml
  ingress:
  enabled: true
  tls:
    enabled: false
    secretName: ""
  annotations:
    kubernetes.io/ingress.class: nginx
    ## allow large bom.xml uploads:
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
  host: minikube.local
  ```

- Install Dependendency Track helm chart with custom values.yaml

  ```s
  kubectl create ns dependency-track

  helm upgrade dependency-track evryfs-oss/dependency-track --namespace dependency-track -f ./values.yaml
  ```

- Run command `minikube ip`
  ```s
  $ minikube ip
  192.168.64.40
  $
  ```
- Add a entry for in /etc/hosts file for the ip and ingress host name

  ```s
  sudo vi /etc/hosts
  #Add the below line
  192.168.64.40 minikube.local
  ```

  Note: Replace the ip with the actual minikube ip from above step.

- Access Dependency track with below name.

```s
open http://minikube.local
```

Note: The default password for dependency track is admin/admin
