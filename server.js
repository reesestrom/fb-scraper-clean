const express = require("express");
const puppeteer = require("puppeteer-extra");
const StealthPlugin = require("puppeteer-extra-plugin-stealth");
const cors = require("cors");
const path = require("path");

puppeteer.use(StealthPlugin());

const app = express();
app.use(express.json());
app.use(cors());

const PORT = process.env.PORT || 3000;


app.post("/scrape", async (req, res) => {
  const { search, city = "saltlakecity" } = req.body;
  const query = encodeURIComponent(search);
  const url = `https://www.facebook.com/marketplace/${city}/search?query=${query}&daysSinceListed=15`;

  try {
    const chromePath = path.join(__dirname, "chrome", "chrome", "chrome");
    const browser = await puppeteer.launch({
      headless: true,
      executablePath: chromePath,
      args: [
        "--no-sandbox",
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-gpu",
        "--single-process",
        "--no-zygote"
      ]
    });
    
    

    const page = await browser.newPage();
    await page.setUserAgent(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/117 Safari/537.36"
    );

    console.log("🔎 Navigating to:", url);
    await page.goto(url, { waitUntil: "domcontentloaded", timeout: 45000 });

    try {
      await page.waitForSelector("a[href*='/marketplace/item/']", { timeout: 15000 });
      await page.waitForTimeout(3000); // small buffer
    } catch (err) {
      console.warn("⚠️ No listing anchor found in time.");
    }

    // Dump first 1000 characters of the loaded HTML for debugging
    const html = await page.content();
    console.log("📄 HTML Snapshot:\n", html.slice(0, 1000));


    const listings = await page.evaluate(() => {
      const anchors = [...document.querySelectorAll("a[href*='/marketplace/item/']")];
      const results = [];

      anchors.forEach((a) => {
        const titleEl = a.querySelector("span[dir='auto'] span");
        const priceEl = a.querySelector("span[dir='auto']");
        const imgEl = a.querySelector("img");

        const title = titleEl?.innerText;
        const priceText = priceEl?.innerText;
        const price = priceText ? parseFloat(priceText.replace(/[^\d.]/g, "")) : null;
        const thumbnail = imgEl?.src;
        const href = a.href.startsWith("http") ? a.href : `https://facebook.com${a.getAttribute("href")}`;

        if (title && price && href) {
          results.push({ title, price, url: href, thumbnail });
        }
      });

      return results.slice(0, 10);
    });

    await browser.close();
    console.log(`✅ Extracted ${listings.length} local listings`);
    res.json({ results: listings });
  } catch (err) {
    console.error("❌ Scraper failed:", err);
    res.status(500).json({ error: err.message });
  }
});

app.get("/health", (req, res) => res.send("OK"));

app.listen(PORT, () => console.log(`🚀 Puppeteer server running on port ${PORT}`));
