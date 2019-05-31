#!/usr/bin/env bash

# 
function automate () {

    cd packer

    packer build -var-file=vars.json apiPacker.json
    packer build -var-file=vars.json dbPacker.json
    packer build -var-file=vars.json frontendPacker.json

    cd ../terraform

    terraform init
    terraform plan -out tfdemo
    terraform apply "tfdemo"

}

automate
