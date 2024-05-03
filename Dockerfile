FROM archlinux:base

# Create a new user and add it to the sudo group
RUN useradd -m testuser && \
    echo "testuser:testuser" | chpasswd && \
    usermod -aG wheel testuser && \
    echo "testuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/testuser && \
    chmod 0440 /etc/sudoers.d/testuser

USER testuser

WORKDIR /home/testuser/app

COPY . .

CMD ["make"]
