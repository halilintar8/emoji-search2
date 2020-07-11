#!/bin/bash

#git clone https://github.com/ahfarmer/emoji-search.git
git clone https://github.com/halilintar8/emoji-search2.git
cd emoji-search2
echo "node_modules" > .dockerignore

cat <<EOF > Dockerfile
FROM nginx:1.17
COPY build/ /usr/share/nginx/html
EOF

cat <<EOF > deployment.yaml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: my-emoji-search
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-emoji-search
  template:
    metadata:
      labels:
        app: my-emoji-search
    spec:
      containers:
        - name: my-emoji-search
          image: localhost:5000/my-emoji-search
          imagePullPolicy: Always
          ports:
            - containerPort: 80
      restartPolicy: Always
---
kind: Service
apiVersion: v1
metadata:
  name: my-emoji-search
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 31000
  selector:
    app: my-emoji-search
EOF

sed -i 's|http://ahfarmer.github.io/emoji-search|http://ahfarmer.github.io|g' package.json
npm install
yarn build
docker build -t my-emoji-search .
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker tag my-emoji-search localhost:5000/my-emoji-search
docker push localhost:5000/my-emoji-search
kubectl apply -f deployment.yaml
minikube service my-emoji-search --url


