FROM maven as build
WORKDIR /app
COPY . .
RUN maven install

FROM openjdk:11
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
EXPOSE 9090
CMD [ "java","-jar","Uber.jar" ]
