#build stage
docker build -t stephengrider/multi-client:latest -t stephengrider/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t stephengrider/multi-server:latest -t stephengrider/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t stephengrider/multi-worker:latest -t stephengrider/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#push latest versionto dockerhub
docker push stephengrider/multi-client:latest
docker push stephengrider/multi-server:latest
docker push stephengrider/multi-worker:latest

#push specific version to DockerHub
docker push stephengrider/multi-client:$SHA
docker push stephengrider/multi-server:$SHA
docker push stephengrider/multi-worker:$SHA

#apply scripts
kubectl apply -f k8s

#imperatibvely set the version
kubectl set image deployments/server-deployment client=stephengrider/multi-client:$SHA
kubectl set image deployments/server-deployment worker=stephengrider/multi-worker:$SHA
kubectl set image deployments/server-deployment server=stephengrider/multi-server:$SHA