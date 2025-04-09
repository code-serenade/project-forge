#!/bin/bash
docker run --detach \
    --hostname xxx.com \
    --env GITLAB_OMNIBUS_CONFIG="external_url 'https://xxx.com/'; gitlab_rails['lfs_enabled'] = true;" \
    --publish 10443:443 --publish 10080:80 --publish 10022:22 \
    --name gitlab \
    --restart always \
    --privileged \
    --volume /data/gitlab/config:/etc/gitlab \
    --volume /data/gitlab/logs:/var/log/gitlab \
    --volume /data/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:17.10.3-ce.0