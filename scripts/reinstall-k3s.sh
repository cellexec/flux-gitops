#!/usr/bin/env bash

sudo systemctl stop k3s
/usr/local/bin/k3s-uninstall.sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

