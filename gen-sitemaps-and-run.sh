#!/bin/bash

# exit on error
set -e

# generate sitemap
rake sitemap:refresh:no_ping

# start puma
puma -C config/puma.rb
