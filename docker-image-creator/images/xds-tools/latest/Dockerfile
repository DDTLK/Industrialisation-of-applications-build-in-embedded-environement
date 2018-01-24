FROM openjdk:9

COPY . /root/INSTALL
RUN /root/INSTALL/setup_image.sh

RUN echo "agent ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/agent

COPY ./agent /home/agent
COPY ./config /home/agent

EXPOSE 8800 50000 22 69

ENTRYPOINT ["/usr/bin/wait_for_net.sh"]
CMD ["/bin/systemd"]
