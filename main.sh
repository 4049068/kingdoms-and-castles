#!/bin/bash

# Function to stop all running VNC sessions
stop_vnc_sessions() {
    # Get the display number of all running VNC servers
    vnc_sessions=$(vncserver -list | grep -o ':[0-9]*')
    
    if [ -z "$vnc_sessions" ]; then
        echo "No running VNC sessions found."
    else
        echo "Stopping all running VNC sessions..."
        for session in $vnc_sessions; do
            vncserver -kill "$session"
        done
    fi
}

# Stop all previous VNC services
stop_vnc_sessions

# Update and install required packages
sudo apt update
sudo apt install -y xfce4 xfce4-terminal tightvncserver novnc websockify -y

# Start VNC server and set password
vncserver

# Configure VNC session to use XFCE
cat <<EOL > ~/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
startxfce4 &
EOL

# Make the xstartup script executable
chmod +x ~/.vnc/xstartup

# Restart VNC server
vncserver -kill :1
vncserver :1

# Start websockify for NoVNC
websockify --web /usr/share/novnc/ 6080 localhost:5901 &

# Notify user
echo "VNC server is running. Access NoVNC at: http://<your-codespace-url>:6080/vnc.html"
