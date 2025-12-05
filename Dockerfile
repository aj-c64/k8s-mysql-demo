FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the jar built by "mvn clean package"
COPY target/*.jar app.jar

# Expose the same port your app uses
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
