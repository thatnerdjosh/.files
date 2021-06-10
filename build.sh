#!/bin/sh

fedoraBase() {
  docker build -f docker/fedora/base.Dockerfile . -t omnidapps/fedora
}

fedoraBase
