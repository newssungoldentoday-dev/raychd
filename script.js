/**
 * Ray Chad — script.js
 * BlueBixt Developers © 2026
 */

// ─────────────────────────────────────────
// 1. TYPING ANIMATION (Terminal Demo)
// ─────────────────────────────────────────
const terminalLines = [
  { type: 'prompt', text: 'raychd connect irc.raychad.local #general' },
  { type: 'output', text: 'Connecting to irc.raychad.local:6667...' },
  { type: 'output', text: 'Welcome to Ray Chad IRC!' },
  { type: 'output', text: 'Joined #general (42 users)' },
  { type: 'msg',    user: 'alice',  text: 'hey everyone 👋' },
  { type: 'msg',    user: 'bob',    text: 'welcome to Ray Chad!' },
  { type: 'msg',    user: 'charlie',text: 'great to have you here!' },
  { type: 'prompt', text: '/msg alice hey! this is awesome' },
  { type: 'output', text: 'Private message sent to alice.' },
];

function runTerminalAnimation() {
  const body = document.getElementById('terminal-body');
  if (!body) return;
  body.innerHTML = '';

  let lineIndex = 0;

  function typeLine(lineObj, callback) {
    const el = document.createElement('div');
    el.className = 't-line';

    if (lineObj.type === 'prompt') {
      el.innerHTML = `<span class="t-prompt">$</span><span class="t-cmd"></span>`;
      body.appendChild(el);
      const cmdEl = el.querySelector('.t-cmd');
      let i = 0;
      const iv = setInterval(() => {
        cmdEl.textContent += lineObj.text[i++];
        if (i >= lineObj.text.length) { clearInterval(iv); setTimeout(callback, 300); }
      }, 28);
    } else if (lineObj.type === 'output') {
      el.innerHTML = `<span class="t-output">${lineObj.text}</span>`;
      body.appendChild(el);
      setTimeout(callback, 200);
    } else if (lineObj.type === 'msg') {
      el.innerHTML = `<span class="t-user">&lt;${lineObj.user}&gt;</span><span class="t-msg"> ${lineObj.text}</span>`;
      body.appendChild(el);
      setTimeout(callback, 400);
    }

    body.scrollTop = body.scrollHeight;
  }

  function nextLine() {
    if (lineIndex >= terminalLines.length) {
      // Add blinking cursor at end
      const cur = document.createElement('div');
      cur.className = 't-line';
      cur.innerHTML = `<span class="t-prompt">$</span><span class="t-cursor"></span>`;
      body.appendChild(cur);
      // Restart animation after delay
      setTimeout(runTerminalAnimation, 4000);
      return;
    }
    typeLine(terminalLines[lineIndex++], nextLine);
  }

  nextLine();
}


// ─────────────────────────────────────────
// 2. COPY BUTTON FOR CODE BLOCKS
// ─────────────────────────────────────────
function initCopyButtons() {
  document.querySelectorAll('.code-block').forEach(block => {
    // Avoid adding duplicate buttons
    if (block.querySelector('.copy-btn')) return;

    const btn = document.createElement('button');
    btn.className = 'copy-btn';
    btn.textContent = 'Copy';
    block.style.position = 'relative';
    block.appendChild(btn);

    btn.addEventListener('click', () => {
      const text = block.innerText.replace('Copy', '').replace('Copied!', '').trim();
      navigator.clipboard.writeText(text).then(() => {
        btn.textContent = 'Copied!';
        btn.classList.add('copied');
        setTimeout(() => {
          btn.textContent = 'Copy';
          btn.classList.remove('copied');
        }, 2000);
      });
    });
  });
}


// ─────────────────────────────────────────
// 3. SMOOTH SCROLL & NAV HIGHLIGHT
// ─────────────────────────────────────────
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', e => {
      const target = document.querySelector(anchor.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });
}

function initNavHighlight() {
  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('.nav-links a');

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLinks.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === '#' + entry.target.id) {
            link.classList.add('active');
          }
        });
      }
    });
  }, { threshold: 0.4 });

  sections.forEach(s => observer.observe(s));
}


// ─────────────────────────────────────────
// 4. MOBILE MENU TOGGLE
// ─────────────────────────────────────────
function initMobileMenu() {
  const nav = document.querySelector('nav');
  if (!nav) return;

  // Create hamburger button
  const burger = document.createElement('button');
  burger.className = 'burger';
  burger.setAttribute('aria-label', 'Toggle menu');
  burger.innerHTML = `<span></span><span></span><span></span>`;
  nav.appendChild(burger);

  const navLinks = document.querySelector('.nav-links');

  burger.addEventListener('click', () => {
    const open = navLinks.classList.toggle('mobile-open');
    burger.classList.toggle('open', open);
  });

  // Close menu when a link is clicked
  navLinks.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      navLinks.classList.remove('mobile-open');
      burger.classList.remove('open');
    });
  });
}


// ─────────────────────────────────────────
// 5. USER COUNT LIVE COUNTER (fun effect)
// ─────────────────────────────────────────
function initUserCounter() {
  const el = document.getElementById('user-count');
  if (!el) return;
  let count = 42;
  setInterval(() => {
    const delta = Math.random() > 0.5 ? 1 : -1;
    count = Math.max(1, count + delta);
    el.textContent = count;
  }, 3000);
}


// ─────────────────────────────────────────
// 6. INJECT DYNAMIC STYLES (for new elements)
// ─────────────────────────────────────────
function injectStyles() {
  const style = document.createElement('style');
  style.textContent = `
    /* Copy Button */
    .copy-btn {
      position: absolute;
      top: 14px;
      right: 14px;
      padding: 5px 12px;
      background: #1a1a1a;
      border: 1px solid #333;
      border-radius: 5px;
      color: #888;
      font-family: 'JetBrains Mono', monospace;
      font-size: 11px;
      cursor: pointer;
      transition: color 0.2s, border-color 0.2s;
    }
    .copy-btn:hover { color: #00FF88; border-color: #00FF88; }
    .copy-btn.copied { color: #00FF88; border-color: #00FF88; }

    /* Nav active link */
    .nav-links a.active { color: #00FF88; }

    /* Mobile menu */
    .burger {
      display: none;
      flex-direction: column;
      gap: 5px;
      background: none;
      border: none;
      cursor: pointer;
      padding: 4px;
    }
    .burger span {
      display: block;
      width: 22px;
      height: 2px;
      background: #666;
      border-radius: 2px;
      transition: transform 0.25s, opacity 0.25s, background 0.2s;
    }
    .burger:hover span { background: #00FF88; }
    .burger.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
    .burger.open span:nth-child(2) { opacity: 0; }
    .burger.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

    @media (max-width: 640px) {
      .burger { display: flex; }
      .nav-links {
        display: none;
        position: absolute;
        top: 61px;
        left: 0; right: 0;
        background: rgba(13,13,13,0.98);
        border-bottom: 1px solid #222;
        flex-direction: column;
        padding: 20px 24px;
        gap: 20px;
      }
      .nav-links.mobile-open { display: flex; }
    }

    /* Terminal body scrollable */
    #terminal-body {
      max-height: 260px;
      overflow-y: auto;
      scrollbar-width: none;
    }
    #terminal-body::-webkit-scrollbar { display: none; }
  `;
  document.head.appendChild(style);
}


// ─────────────────────────────────────────
// INIT — Run everything on DOM ready
// ─────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  injectStyles();
  runTerminalAnimation();
  initCopyButtons();
  initSmoothScroll();
  initNavHighlight();
  initMobileMenu();
  initUserCounter();

  console.log('%c ray#chad ', 'background:#00FF88;color:#000;font-weight:bold;font-size:14px;padding:4px 8px;border-radius:4px;');
  console.log('%c IRC Chat · BlueBixt Developers © 2026 ', 'color:#666;font-size:11px;');
});
          
