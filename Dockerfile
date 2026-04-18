# ---------- DEPENDENCIES --------------

# bazowe info: Linux alpine z javą 25
FROM eclipse-temurin:25-jdk-alpine AS build
# cd app -> tutaj będziemy budować
WORKDIR /app

# kopiwanie plików konfiguracyjnych Gradle
# skrypty gradle wrapper
COPY gradlew .
# folder (więc do folderu gradle a nie do workdir)
# jar i properties gradle wrappera do instalacji
COPY gradle gradle

# definicje: plugins, dependencies, java itp.
COPY build.gradle .
# tylko nazwa projektu
COPY settings.gradle .
RUN ./gradlew dependencies --no-daemon

# ---------- BUDOWANIE -----------------
# ew. dodajemy wykonywanie dla gradlew na Linux (jakby nie było)
RUN chmod +x gradlew

# kod źródłowy - aplikacja
COPY src src

# tworzymy plik .jar
RUN ./gradlew bootJar --no-daemon


# ---------- URUCHOMIENIE --------------
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# kopiujemy to co dostaliśmy w build
# build/libs - tworzone automatycznie
COPY --from=build /app/build/libs/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
