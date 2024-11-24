# Build backend docker image
```bash
docker buildx build --no-cache --platform=linux/amd64 -t backend:1.0.0 -f Dockerfile.backend .
```

# Build frontend docker image
```bash
docker buildx build --no-cache --platform=linux/amd64 -t frontend:1.0.0 -f Dockerfile.frontend .
```

# Build redis docker image
```bash
docker buildx build --no-cache --platform=linux/amd64 -t redis:1.0.0 -f Dockerfile.redis .
```

# Tag backend docker image
Example:
```bash
docker tag backend:1.0.0 docker.io/yiadh/backend:1.0.0
```

# Tag frontend docker image
Example:
```bash
docker tag frontend:1.0.0 docker.io/yiadh/frontend:1.0.0
```

# Tag redis docker image
Example:
```bash
docker tag redis:1.0.0 docker.io/yiadh/redis:1.0.0
```

# Log into docker
Example:
```bash
$ docker login
Log in with your Docker ID or email address to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com/ to create one.
You can log in with your password or a Personal Access Token (PAT). Using a limited-scope PAT grants better security and is required for organizations using SSO. Learn more at https://docs.docker.com/go/access-tokens/

Username: yiadh
Password:
Login Succeeded
```

# Push backend docker image
Example:
```bash
docker push docker.io/yiadh/backend:1.0.0
```

# Push frontend docker image
Example:
```bash
docker push docker.io/yiadh/frontend:1.0.0
```

# Push redis docker image
Example:
```bash
docker push docker.io/yiadh/redis:1.0.0
```

#Update k8s yaml files with Docker images
##k8s yaml files:
- redis.yaml: contains deployment and service for redis
- backend.yaml: contains deployment, service and a configmap for backend.
- frontend: contains deployment and service for frontend

##Images present in public docker hub and already used in k8s yaml files are:
- docker.io/yiadh/backend:1.0.0
- docker.io/yiadh/frontend:1.0.0
- docker.io/yiadh/redis:1.0.0

#Deploy Applications on kubernetes
```bash
kubectl apply -f <yaml file> -n <namespace>
```

Example: deploy apps in default namespace
```bash
kubectl apply -f redis.yaml -n default
kubectl apply -f frontend.yaml -n default
kubectl apply -f backend.yaml -n default

```
