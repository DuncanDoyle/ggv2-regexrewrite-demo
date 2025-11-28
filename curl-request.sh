#!/bin/sh

# curl -v http://api.example.com/get

curl -v -H "Authorization: basic $(printf 'user:password' | base64)" http://api.example.com/v1/202/status
