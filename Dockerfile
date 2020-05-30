FROM openjdk:8-jre
WORKDIR /root/
COPY target/demo-0.0.1-SNAPSHOT.jar .
EXPOSE 8080
CMD ["java","-jar","demo-0.0.1-SNAPSHOT.jar"]