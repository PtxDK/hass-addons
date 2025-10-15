# Change SSH Port
gitlab_rails['gitlab_shell_ssh_port'] = 2424

# Set external URL
external_url 'http://192.168.1.2'  # replcae with your server url

# (Optional) for Traefik integration, disable TLS termination in GitLab
letsencrypt['enable'] = false
nginx['listen_port'] = 80
nginx['listen_https'] = false