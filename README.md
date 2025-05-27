# Broken Link Scanner

A tool to scan websites for broken links that could potentially be taken over. It checks for common platform links (Facebook, Twitter, etc.) and verifies if they show signs of being vulnerable to takeover.

## Features

- Scan single URL or list of URLs
- Headless browser crawling withedp
-edp
- Custom template system for platform detection
- Discord webhook notifications
- Color-coded console output
- Continuous monitoring mode (24-hour intervals)

## Requirements

- Go 1.16+
- Chrome/Chromium browser
- Discord webhook URL (for notifications)

## Supported Platforms
Facebook
Twitter/X
Instagram
TikTok
YouTube
LinkedIn
Telegram
GitHub
Etc...

## Usage

### Basic Commands

**Scan a single URL:**

`./bls -u https://example.com -t templates.txt -m onetime`

Scan multiple URLs from a file:

`./bls -l urls.txt -t templates.txt -m infinite`

Command Line Options
Flag	Description	Required	Default
-u	Single URL to scan	Yes*	-
-l	File containing list of URLs to scan	Yes*	-
-t	Template file path	Yes	-
-m	Operation mode	Yes	-
* Either -u or -l must be provided

Modes of Operation
One-time Scan (-m onetime)

Scans targets once and exits
Ideal for quick checks
`./bls -u https://example.com -t templates.txt -m onetime`

Continuous Monitoring (-m infinite)

Scans targets every 24 hours
Runs indefinitely until manually stopped

`./bls -l urls.txt -t templates.txt -m infinite`
