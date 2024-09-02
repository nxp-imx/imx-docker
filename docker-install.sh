#!/bin/bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $(whoami)
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Please log out and back in again to refresh your permissions"