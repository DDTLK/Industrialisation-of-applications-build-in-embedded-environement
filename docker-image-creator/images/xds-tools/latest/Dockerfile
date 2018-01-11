FROM openjdk:9

COPY . /root/INSTALL
RUN /root/INSTALL/setup_image.sh

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/jenkins

VOLUME ["/var/lib/jenkins"]
EXPOSE 50000 22 69

ENTRYPOINT ["/usr/bin/wait_for_net.sh"]
CMD ["/bin/systemd"]
