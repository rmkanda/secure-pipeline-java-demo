# Installation Steps for Dependency Track

- Setup helm repo

  ```s
  helm repo add evryfs-oss https://evryfs.github.io/helm-charts/

  helm repo update
  ```

- Create a file with below contents - dtrack-values.yaml

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
  frontend:
    env:
      - name: API_BASE_URL
        value: "http://localhost:9002"
  ```

- Install Dependendency Track helm chart with custom dtrack-values.yaml

  ```s
  kubectl create ns deptrack

  helm install deptrack evryfs-oss/dependency-track --namespace deptrack -f ./dtrack-values.yaml
  ```

- Port Forward the services

  ```s
  kubectl port-forward svc/deptrack-dependency-track-apiserver 9002:80 -n deptrack
  kubectl port-forward svc/deptrack-dependency-track-frontend 9001:80 -n deptrack
  ```

- Access the UI using http://localhost:9001/dashboard

Note: The default password for dependency track is admin/admin

## Another workaround:
(Note: Need to remove the API_BASE_URL env variable in the custom helm values)

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
