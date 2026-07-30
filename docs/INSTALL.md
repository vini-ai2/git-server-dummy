# Installing Git Smart HTTP Server

## Install packages

```bash
sudo apt update
sudo apt install nginx fcgiwrap git
```

## Copy nginx configuration

```bash
sudo cp install/nginx/git.conf \
/etc/nginx/sites-available/git
```

## Enable configuration

...

## Restart nginx

...

## Verify

curl ...
```