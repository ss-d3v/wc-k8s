# Base image
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Copy the shell script files
COPY  wisecow.sh .

# Set execute permissions for the shell script
RUN chmod +x wisecow.sh

# Expose application port
EXPOSE 4499

# Install prerequistes
RUN apt update && \
    apt install cowsay fortune netcat-openbsd -y

# Add cowsay and fortune in PATH variable
ENV PATH="${PATH}:/usr/games"

# Start the application
CMD ["./wisecow.sh"]
