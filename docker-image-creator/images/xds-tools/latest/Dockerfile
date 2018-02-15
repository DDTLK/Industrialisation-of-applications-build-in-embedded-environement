FROM openjdk:9

COPY . /root/INSTALL
RUN /root/INSTALL/setup_image.sh

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/jenkins

COPY ./agent /home/jenkins
COPY ./config /home/jenkins

EXPOSE 8800 50000 22 69

ENTRYPOINT ["/usr/bin/wait_for_net.sh"]
CMD ["/bin/systemd"]
