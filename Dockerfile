FROM land007/proxy:latest

RUN apt-get update -y --allow-releaseinfo-change && apt-get install -y iptables && apt-get clean
ENV INIP=192.168.1.1
ENV LANIP=192.168.1.1
ADD iptables.sh	/
RUN chmod +x /iptables.sh
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

CMD /task.sh ; /iptables.sh ; /start.sh ; bash

#docker build -t land007/proxy_iptables:latest .
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/proxy_iptables:latest --push .
#docker rm -f proxy_iptables; docker run -it --restart=always -e "username=land007" --privileged --cap-add=NET_ADMIN -e "password=81dc9bdb52d04dc20036dbd8313ed055" -e "INIP=192.168.1.47" -e "LANIP=192.168.1.1" -p 8080:8080 -p 8888:8888 --name proxy_iptables land007/proxy_iptables:latest
#docker rm -f proxy_iptables; docker run -it --restart=always -e "username=land007" --privileged --cap-add=NET_ADMIN -e "password=81dc9bdb52d04dc20036dbd8313ed055" -e "INIP=192.168.1.47" -e "LANIP=192.168.1.1/24" -p 8080:8080 -p 8888:8888 --name proxy_iptables land007/proxy_iptables:latest
#curl --proxy http://land007:1234@192.168.1.47:8080 http://192.168.1.1
# export HTTP_PROXY=http://land007:1234@192.168.1.47:8080
#curl http://192.168.1.1