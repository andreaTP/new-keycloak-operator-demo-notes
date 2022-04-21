
Start with a clean cluster:

```bash
minikube stop && minikube delete && minikube start --driver=docker --memory 8192 --cpus 3
```

Enable the ingress addon:

```bash
minikube addons enable ingress
```

Install the operator using the instructions:
https://www.keycloak.org/operator/installation
"Vanilla Kubernetes Installation"

Install the CRDs
```
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/18.0.0/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/18.0.0/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
```

And install the operator:
```
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/18.0.0/kubernetes/kubernetes.yml
```

And now you can install a Keycloak instance:

- Deploy a postgres instance:

```
kubectl apply -f example-postgres.yaml
```

- Create Database username and password secret:

```
kubectl create secret generic keycloak-db-secret --from-literal=username=postgres --from-literal=password=testpassword
```

- Create a new TLS secret certificate:

```
openssl req -subj '/CN=test.keycloak.org/O=Test Keycloak./C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
```

```
kubectl create secret tls example-tls-secret --cert certificate.pem --key key.pem
```

- Create a Custom Keycloak image:

Show the Dockerfile, build and push the image:

```
docker build . -t andreatp/custom-keycloak:18.0.0
docker push docker.io/andreatp/custom-keycloak:18.0.0
```

- Finally deploy Keycloak:

```
kubectl apply -f example-keycloak.yaml
```

- Check that is up and running:

```
minikube tunnel
```
edit the hosts file to match with the example configuration:
```
sudo nano /etc/hosts
```
add:
```
127.0.0.1 example.com
```
and finally:

```
curl -s https://example.com/realms/master --insecure
```
or using Firefox:

```
https://example.com/realms/master
```

- Realm Import CRD

```
kubectl apply -f example-realm.yaml
```

Realm is accessible:

```
curl -s https://example.com/realms/count0 --insecure
```
