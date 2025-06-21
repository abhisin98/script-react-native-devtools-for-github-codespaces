# React Native DevTools for GitHub Codespaces

This script streamlines launching React Native DevTools in GitHub Codespaces by rewriting the DevTools URL with a tunnel URL and opening it in your system browser. It's designed for use with `expo start --tunnel`.

## Features

- Rewrites the host of the incoming `--app=<URL>` to a tunnel-accessible URL
- Opens the updated URL using your OS's default browser opener
- Supports Linux, macOS, and Windows environments

## Setup

1. **Configure your project:**
   Add the following to your `.env` file:
   ```sh
   EDGE_PATH=$PWD/browser.sh
   ```
2. **Create the script:**
   Create a file named `browser.sh` in your project root with the following content:

   ```sh
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

     # Detect platform and open URL accordingly
     if [[ "$OSTYPE" == "linux-gnu"* ]]; then
       xdg-open "$FINAL_URL"
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
   ```

3. **Edit the tunnel URL:**
   In browser.sh, set your expo tunnel url:
   ```sh
   TUNNEL_URL="http://my-tunnel-8081.exp.direct"
   ```
4. **Make the script executable:**
   Ensure the script has execute permissions:
   ```sh
    chmod +x browser.sh
   ```
5. **Launch Expo with tunnel:**
   ```sh
    npx expo start --tunnel
   ```

## How It Works

The script:

- **Accepts** a `--app=<URL>` argument from Expo
- **Extracts** the path and query from the original URL
- **Reconstructs** the URL using the provided `TUNNEL_URL` as host
- **Opens** the final URL in your browser using `xdg-open`, `open`, or `start` depending on platform

## Example

If the original URL is:

```sh
http://localhost:8081/debugger-frontend/rn_fusebox.html?ws=%2Finspector%2Fdebug%3Fdevice%3D<device-id>%26page%3D<page>&sources.hide_add_folder=true&unstable_enableNetworkPanel=true
```

And your `TUNNEL_URL` is:

```sh
http://my-tunnel-8081.exp.direct
```

The opened URL becomes:

```sh
http://my-tunnel-8081.exp.direct/debugger-frontend/rn_fusebox.html?ws=%2Finspector%2Fdebug%3Fdevice%3D<device-id>%26page%3D<page>&sources.hide_add_folder=true&unstable_enableNetworkPanel=true
```

## Notes

- Ensure your tunnel URL is accessible from your local machine or collaborators.
- Script supports most UNIX-like systems and Windows environments that define `OSTYPE`.

---

Happy debugging! 🚀

---
