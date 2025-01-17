FROM openjdk:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 80
CMD ["sh", "-c", "java -jar /app.jar --server.port=80"]
