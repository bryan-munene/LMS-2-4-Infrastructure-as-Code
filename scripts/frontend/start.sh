#!/usr/bin/env bash

# SET PM2 TO RUN THE APP IN THE BACKGROUND
function configurePM2 {
    cd ah-bird-box-frontend
    source .env
    
    pm2 start npm --name "AH-Birdbox" -- start
    pm2 startup
    sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
    pm2 save
}

configurePM2
