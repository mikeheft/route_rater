#!/bin/bash

port=3000  # Default port

# Parse command line options
while getopts ":p:" opt; do
  case ${opt} in
    p)
      port=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Start Redis in daemon mode
redis-server --daemonize yes

# Start Rails server on specified port
echo "Starting Rails server on port $port"
bundle exec rails server -p $port
