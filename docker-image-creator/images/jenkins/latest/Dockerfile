FROM openjdk:8

COPY . /root/INSTALL
RUN /root/INSTALL/setup_image.sh

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins:jenkins
WORKDIR /home/jenkins

VOLUME ["/var/lib/jenkins"]
RUN chmod -R 777 /var/lib/jenkins

ENTRYPOINT ["/usr/bin/wait_for_net.sh"]
CMD ["/bin/systemd"]
