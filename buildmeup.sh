#!/bin/bash
docker-compose --env-file .env.docker up nginx db app phpmyadmin workspace --build
