Emoji Search
---

Created with *create-react-app*. See the [full create-react-app guide](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md).



Install
---

`npm install`



Usage
---

`npm start`



Credited by
---

[https://github.com/ahfarmer/emoji-search.git](https://github.com/ahfarmer/emoji-search.git)


How To
---

for ubuntu 18.04,  install these required software :
- virtualbox virtualbox-ext-pack
- docker
- npm
- nodejs
- kubectl
- kubernetes with minikube

create these 3 files in the directory emoji-search :
- Dockerfile
- .dockerignore
- deployment.yaml

create = provisioning.sh
- chmod 755 provisioning.sh
- run provisioning.sh

then run = minikube service my-emoji-search --url
- my output example = http://192.168.99.100:31000/
- open this url in your browser


