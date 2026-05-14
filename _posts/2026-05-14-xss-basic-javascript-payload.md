---
layout: single
title: "XSS — Basic JavaScript Payload"
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
  - reflected-xss
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
excerpt: "Understanding the fundamental JavaScript payload structure used in Cross-Site Scripting attacks — the foundation before moving to advanced XSS techniques."
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

## What This Is

Before you can run any XSS attack, you need to understand what the browser is actually executing. This is the base JavaScript structure — the logic behind how payloads like `alert(1)` work under the hood.

<div class="tool-cmd">// Basic JS structure used in XSS payloads</div>

```javascript
function processData(data) {
  data.items.forEach(item => {
    console.log(item)
  });
}

let foo = {
  items: [
    "Hello",
    "Hacker",
    "Here"
  ]
}

processData(foo)
```

## Why It Matters

When you inject `<script>alert(1)</script>` into a page, the browser parses and runs it as JavaScript. Understanding how the runtime processes objects, loops, and functions lets you craft more complex payloads — data extraction, DOM manipulation, exfiltration — not just pop-ups.

## Basic Injection Starters

<div class="tool-cmd">// Test these in input fields, URL params, headers</div>

```javascript
<script>alert(1)</script>
<script>alert(document.domain)</script>
<script>alert(document.cookie)</script>
```

<div class="remediation-box"><strong>Fix:</strong> Output encode all user-supplied data. Use <code>htmlspecialchars()</code> in PHP, <code>escapeHtml()</code> in Java, or framework-level templating that auto-escapes by default.</div>

---

*All payloads documented for authorised security testing only. Do not use against systems without explicit written permission.*

<a href="https://buymeacoffee.com/sweshinfosec" target="_blank" style="font-family:monospace;font-size:13px;color:#9fef00;">&#9749; Buy Me a Coffee</a>
&nbsp;&nbsp;
<a href="https://www.patreon.com/c/SweshInfoSec" target="_blank" style="font-family:monospace;font-size:13px;color:#ff9800;">Patreon &rarr;</a>
