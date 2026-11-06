// Capture the actual Flutter web build, rather than a separate design mockup.
const { chromium } = require(process.env.NAMER_PLAYWRIGHT_PATH || 'playwright');
const { spawn } = require('node:child_process');
const fs = require('node:fs/promises');

(async () => {
  const server = spawn('python3', ['-m', 'http.server', '8080', '--bind', '127.0.0.1', '--directory', 'build/web']);
  let browser;
  try {
    for (let attempt = 0; attempt < 40; attempt++) {
      try {
        const response = await fetch('http://127.0.0.1:8080');
        if (response.ok) break;
      } catch { /* The local server is still starting. */ }
      if (attempt === 39) throw new Error('Preview server did not start');
      await new Promise(resolve => setTimeout(resolve, 250));
    }
    browser = await chromium.launch({ headless: true });
    await fs.mkdir('preview-artifacts', { recursive: true });
    for (const [name, viewport] of Object.entries({ mobile: { width: 390, height: 844 }, desktop: { width: 1440, height: 1000 } })) {
      const page = await browser.newPage({ viewport, deviceScaleFactor: 1 });
      await page.addInitScript(() => {
        window.addEventListener('flutter-first-frame', () => { window.flutterReady = true; });
      });
      await page.goto('http://127.0.0.1:8080');
      await page.waitForFunction(() => window.flutterReady === true, null, { timeout: 60000 });
      // The first frame precedes the final font rasterization in CanvasKit.
      await page.waitForTimeout(2000);
      await page.screenshot({ path: `preview-artifacts/namer-${name}.png` });
      await page.close();
    }
  } finally {
    if (browser) await browser.close();
    server.kill();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
