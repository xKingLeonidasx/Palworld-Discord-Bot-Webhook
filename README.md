# Palworld Server Status – Discord Webhook Updater

This PowerShell script monitors your Palworld dedicated server and automatically updates a Discord webhook message with real-time information such as server status, player count, memory usage, uptime, and next scheduled restart.

Perfect for automated status dashboards in Discord!

## 📌 Features

- 🟢 Online/Offline server detection
- 🧠 Memory commit (VRAM) monitoring with health status
- 👥 Player count + Player list via ARRCON
- ⏱ Server uptime tracking
- 🔁 Next scheduled restart timer (reads from Task Scheduler)
- 🎨 Color-coded Discord embed based on server health
- 🔄 Uses PATCH to update an existing Discord webhook message (does not spam new messages)

## 📁 Requirements

- Windows system running your Palworld server
- PowerShell 5 or newer
- ARRCON (for RCON queries)
- Task Scheduler configured with a task called "Reboot Server"
- A Discord webhook
- Webhook message ID (since this script edits the message)
- Update the RCON password and port on the script specific to your server.
- Can change the Patch message for Discord at bottom of script.


# ⚙️ Script Overview

## 🔍 Server Status
Checks if the process:

PalServer-Win64-Shipping-Cmd

is running.

---

## 💾 VRAM (Committed Memory) Check

- **< 24 GB → Good**  
- **24–28 GB → Critical**  
- **> 28 GB → Restarting**

---

## 🎮 Player Info via ARRCON

Runs:

showplayers

Cleans and formats the player list.

---

## ⏱ Uptime & Next Restart

- Pulls process start time  
- Reads Task Scheduler for next reboot

---

## 📨 Webhook Update

Sends a PATCH request:


to update the Discord embed in place.

---

## ▶️ Running the Script

Just run:

The included ps1 file.


## 📬 How to Get a Discord Webhook URL

1. **Open the channel settings**
    - Right-click the channel → Edit Channel

2. **Go to:**
    - Integrations → Webhooks

3. **Create a new webhook**
    - Give it a name and select the output channel.

4. **Click Copy Webhook URL**
    - It looks like:
    ```plaintext
    https://discord.com/api/webhooks/<WebhookID>/<WebhookToken>
    ```

## ✏️ Getting the “Edit Message” Webhook URL

This script edits an existing message, not posts a new one, so you must append the Message ID.

### Step 1 — Enable Developer Mode

- Discord → User Settings → Advanced → Enable Developer Mode

### Step 2 — Copy your webhook message ID

- Right-click the webhook’s message → Copy Message ID

### Step 3 — Build the full URL:
```plaintext
https://discord.com/api/webhooks/<WebhookID>/<WebhookToken>/messages/<MessageID>
