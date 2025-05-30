# Scripts

Here are some extra info about the scripts.

## `reinstall-k3s.sh`

This script:

- stop the k3s service
- uninstall the current k3s installation
- install k3s again (using `--write-kubeconfig-mode 644`)   
 
## `flux-bootstrap.sh`

This script:

- bootstrap flux via ssh on github

## `add-sops-gpg-secret.sh`

> [!WARNING]
> The namespace `flux-system` need to be present before running, otherwise it will fail!
> If you run the `flux-bootstrap.sh` script before, it will be created there.

This script:

- load a GPG private key into a `Secret` within the `flux-system` namespace

### GPG Keys

> [!ERROR]
> When creating a new GPG key, you **CANNOT USE A PASSPHRASE**!
> Otherwise sops can't decode your secrets!

**Create a GPG key:**

```bash
gpg --full-generate-key
```

**List your GPG keys:**

```bash
gpg --list-secret-keys --keyid-format LONG
```

**Export a public key:**

```bash
gpg --armor --export <armor_id > gpg.pub
```

**Export a private key:**

```bash
gpg --export-secret-keys --armor <armor_id> > gpg.asc
```

