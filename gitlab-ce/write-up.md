Source: https://www.patreon.com/posts/110502880?collection=749468

# GitLab Tutorial Write-Up

**Video:** How To Self-Host Your Own Git Platform (GitLab)!

**Skills:** Medium - High

**Prerequisites:** Docker installed

## Installation

### Project Files

Create the following files in your project directory

```
project-directory/
├── config/
│   └── gitlab.rb
├── logs/
├── data/
└── docker-compose.yaml
```

Template for `config/gitlab.rb`

```toml
# Change SSH Port
gitlab_rails['gitlab_shell_ssh_port'] = 2424

# Set external URL
external_url 'https://your-servers-dns-name'  # replcae with your server url

# (Optional) for Traefik integration, disable TLS termination in GitLab
letsencrypt['enable'] = false
nginx['listen_port'] = 80
nginx['listen_https'] = false
```

Template for `docker-compose.yaml`

```yaml
---
services:
  gitlab:
    image: gitlab/gitlab-ce:17.0.6-ce.0  # replace with current version!
    container_name: your-container-name
    ports:
      - '2424:22'
    volumes:
      - ./config:/etc/gitlab
      - ./logs:/var/log/gitlab
      - ./data:/var/opt/gitlab
    shm_size: '256m'
    networks:
      - your-traefik-network  # replace with your network
    labels:
      - traefik.enable=true
      - traefik.http.routers.gitlab-https.rule=Host(`your-servers-dns-name`)  # replace with your server url
      - traefik.http.routers.gitlab-https.entrypoints=websecure
      - traefik.http.routers.gitlab-https.tls=true
      - traefik.http.routers.gitlab-https.tls.certresolver=your-cert-resolver  # replace with your cert-resolvername
      - traefik.http.services.gitlab-service.loadbalancer.server.port=80
    restart: unless-stopped
networks:
  your-traefik-network:
    external: true
```

Run the container with the following command

```bash
docker compose up -d
```

### Log into the admin page

Read the initial root password

```bash
sudo docker exec -it gitlab-demo-1 grep 'Password:' /etc/gitlab/initial_root_password
```