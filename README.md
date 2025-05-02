# 🚀 flux-gitops

This repository bootstraps a [Flux](https://fluxcd.io/) GitOps setup using **SSH authentication** for a public GitHub repo. It also includes instructions to set up a **local Kubernetes cluster with kind**.

> Maintained by [@cellexec](https://github.com/cellexec) — MIT licensed.

---

## 📦 Prerequisites

- [flux CLI](https://fluxcd.io/flux/installation/) (auto-installed by the script)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/get-docker/)
- [kind](https://kind.sigs.k8s.io/) (for local cluster)

---

## ⚙️ Setup

### 1. Fork the repository
> [!Warning]
> You __need__ to be **owner** of a gitops repo in order to load it with the flux cli!

### 2. Create a PAT in GitHub
A Personal Access Token (PAT) is used to access your git repository.

You can create such a token here: [Developer Settings/Peronal Access Token](https://github.com/settings/personal-access-tokens/new).

### 3. Bootstrap flux via its cli:

```bash
flux bootstrap github \
    --owner=<your_username> \ 
    --repository=flux-gitops \ 
    --branch=main \ 
    --personal \ 
    --path=clusters/homelab
```

Then enter the PAT you've created:

```bash
Please enter your GitHub personal access token (PAT):
```

### 3. Check cluster for installation

### 1. Clone the repository

```bash
git clone git@github.com:cellexec/flux-gitops.git
cd flux-gitops
```

### 2. Configure your environment

Copy and edit the `.env` file:

```bash
cp .env.example .env
```

Fill it with your values:

```dotenv
GITHUB_USER=cellexec
REPO_NAME=flux-gitops
CLUSTER_NAME=local-dev
```

> [!TIP]
> If you forked this repository, then change these values to match your user / repository.

---

## 🌱 Create a Local Kubernetes Cluster (kind)

```bash
kind create cluster --name $CLUSTER_NAME
```

Check it works:

```bash
kubectl cluster-info --context kind-$CLUSTER_NAME
```

---

## 🚀 Bootstrap Flux

Run the bootstrap script:

```bash
./flux-bootstrap.sh
```

This will:

- Generate an RSA SSH key (if missing)
- Connect to your GitHub repo via SSH
- Push cluster state files under `clusters/<CLUSTER_NAME>`

---

## 🔐 Add the SSH Public Key to GitHub

After bootstrapping, you'll be shown a public SSH key. Add it as a **Deploy Key** in GitHub:

> **GitHub → flux-gitops → Settings → Deploy Keys → Add Deploy Key**  
> ✅ Check **Allow write access**

---

## 📁 Repo Structure

```text
.
├── flux-bootstrap.sh       # Bootstrap script
├── .env.example            # Environment variable template
├── clusters/
│   └── local-dev/          # Cluster manifests
└── README.md               # This file
```

---

## 🧹 Clean Up

To remove the local kind cluster:

```bash
kind delete cluster --name $CLUSTER_NAME
```

---

## 🧠 Tip

You can customize the `clusters/` folder with your own `kustomization.yaml`, `gotk-components.yaml`, or app configs to deploy automatically after bootstrapping.

---

## 🐙 MIT License

This project is [MIT licensed](LICENSE) and maintained by [@cellexec](https://github.com/cellexec).

