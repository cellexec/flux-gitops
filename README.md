# Flux

## Commands

### SOPS

```bash
# List all GPG keys
gpg --list-keys

# Extract secret key
gpg --export-secret-keys --armor 981D24BE7469037F9C4D0BEEBED12DF928B52181 > gpg.asc

# Copy via scp
scp gpg.asc <server>:/home/user/projects/flux-gitops

# Create secret from gpg
k create secret generic sops --from-file=gpg.asc=gpg.asc

```
