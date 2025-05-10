#!/usr/bin/env bash

project=$(ls $HOME/dev | fzf)

zellij list-sessions | grep $project || zellij new-session -s $project

