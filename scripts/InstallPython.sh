#!/bin/bash

# Function to check and install Python on Fedora
install_python_fedora() {
    echo "Checking for Python installation on Fedora..."
    if command -v python3 >/dev/null; then
        echo "Python is already installed."
    else
        echo "Installing Python..."
        sudo dnf install -y python3
    fi
}
