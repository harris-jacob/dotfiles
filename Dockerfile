FROM archlinux:base

# Create a new user and add it to the sudo group
RUN useradd -m testuser && echo "testuser:testuser" | chpasswd && adduser testuser sudo

# Switch to the new user
USER testuser

# Set the working directory in the container
WORKDIR /home/testuser/app

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Run the Makefile
CMD ["make"]
