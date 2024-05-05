FROM archlinux:base-devel

# Create a new user and add it to the sudo group
RUN useradd -m testuser && \
    echo "testuser:testuser" | chpasswd && \
    usermod -aG wheel testuser && \
    # Ensure the /etc/sudoers.d directory exists
    mkdir -p /etc/sudoers.d && \
    # Allow testuser to execute any command without a password
    echo "testuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/testuser && \
    chmod 0440 /etc/sudoers.d/testuser

USER testuser

WORKDIR /home/testuser/app

# sync the package database so its not slow during test
RUN sudo pacman -Syu --noconfirm
RUN sudo pacman -S git make

COPY . .

CMD ["make"]
