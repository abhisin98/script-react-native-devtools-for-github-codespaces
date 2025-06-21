#!/bin/bash

# Check if --app argument is provided
if [ -z "$1" ]; then
  echo "Error: No argument provided."
  exit 1
fi

# Check for proper format: --app=<URL>
if [[ "$1" == --app=* ]]; then

  # Extract the URL from the --app argument
  APP_URL=$(echo "$1" | sed 's/--app=//')

  # Define your tunnel URL here
  TUNNEL_URL="http://my-tunnel-8081.exp.direct"

  # Extract path and query from the original URL
  PATH_QUERY=$(echo "$APP_URL" | sed -E 's|https?://[^/]+||')

  # Construct the new URL using the tunnel URL
  FINAL_URL="$TUNNEL_URL$PATH_QUERY"
  echo "Opening URL: $FINAL_URL"

  # Detect platform and open URL accordingly
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$FINAL_URL" || sensible-browser "$FINAL_URL"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    open "$FINAL_URL"
  elif [[ "$OSTYPE" == "cygwin"* || "$OSTYPE" == "msys"* ]]; then
    start "$FINAL_URL"
  else
    echo "Unsupported OS. Please open this URL manually: $FINAL_URL"
    exit 1
  fi
else
  echo "Error: Invalid argument format. Expected --app=<URL>"
  exit 1
fi
