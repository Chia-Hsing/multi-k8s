# 會留下 latest 版本是為了要讓其他使用這個 docker hub 的工程師能在需要時拿到最新版本的 image，不必煩惱要如何取得 SHA 的版本號。
docker build -t ausgeflippte/docker-multi-client:latest -f ausgeflippte/docker-multi-client:$SHA ./client
docker build -t ausgeflippte/docker-multi-api:latest -f ausgeflippte/docker-multi-api:$SHA ./server
docker build -t ausgeflippte/docker-multi-worker:latest -f ausgeflippte/docker-multi-worker:$SHA ./worker

docker push docker-multi-client:latest
docker push docker-multi-api:latest
docker push docker-multi-worker:latest

docker push docker-multi-client:$SHA
docker push docker-multi-api:$SHA
docker push docker-multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=ausgeflippte/docker-multi-api:$SHA
kubectl set image deployments/client-deployment client=ausgeflippte/docker-multi-client:$SHA
kubectl set image deployments/worker-deployment worker=ausgeflippte/docker-multi-worker:$SHA
