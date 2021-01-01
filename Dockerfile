FROM land007/proxy:latest

RUN apt-get update && apt-get install -y iptables && apt-get clean
ENV LANIP=192.168.1.1
ADD iptables.sh	/
RUN chmod +x /iptables.sh

CMD /task.sh ; /iptables.sh ; /start.sh ; bash

#docker build -t land007/proxy_iptables:latest .
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/proxy_iptables:latest --push .
#docker run -it --restart=always -e "username=land007" --privileged --cap-add=NET_ADMIN -e "password=81dc9bdb52d04dc20036dbd8313ed055" -e "LANIP=192.168.1.1" -p 8080:8080 -p 8888:8888 --name proxy land007/proxy:latest
