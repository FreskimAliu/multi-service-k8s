#! /bin/bash

docker build -t freskimaliu/multi-client:latest -t freskimaliu/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t freskimaliu/multi-server:latest -t freskimaliu/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t freskimaliu/multi-worker:latest -t freskimaliu/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push freskimaliu/multi-client:latest
docker push freskimaliu/multi-server:latest
docker push freskimaliu/multi-worker:latest

docker push freskimaliu/multi-client:$SHA
docker push freskimaliu/multi-server:$SHA
docker push freskimaliu/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=freskimaliu/multi-server:$SHA
kubectl set image deployments/client-deployment client=freskimaliu/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=freskimaliu/multi-worker:$SHA