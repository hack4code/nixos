#!/usr/bin/env bash


curl -X POST -H "Content-Type: application/json" -d '{"spiders": ["all"]}' http://127.0.0.1:8080/submit/crawl


# vim: ts=4 sw=4 sts=4 ft=bash et:
