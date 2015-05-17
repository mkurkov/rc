#!/bin/sh

ansible-playbook -K -i ansible/inventory ansible/main.yml
