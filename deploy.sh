# Build docker images for each service
docker build -t kriceuqac/multi-client:latest -t kriceuqac/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kriceuqac/multi-server:latest -t kriceuqac/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t kriceuqac/multi-worker:latest -t kriceuqac/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images to docker hub
docker push kriceuqac/multi-client:latest kriceuqac/multi-client:$SHA
docker push kriceuqac/multi-server:latest kriceuqac/multi-server:$SHA
docker push kriceuqac/multi-worker:latest kriceuqac/multi-worker:$SHA

# Apply k8s configuration
kubectl apply -f k8s

kubectl set image deployments/server-deployment server=kriceuqac/multi-server:$SHA
kubectl set image deployments/client-deployment client=kriceuqac/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kriceuqac/multi-worker:$SHA
