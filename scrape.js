const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL || 'https://rahulhingve.pro';


async function scrapeWebsite() {

  console.log(`Starting to scrape: ${url}`);
  
  const browserOptions = {
    executablePath: '/usr/bin/chromium',
    headless: 'new', 
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage', 
      '--disable-gpu', 
    ]
  };
  
  let browser;
  
  try {
   
    browser = await puppeteer.launch(browserOptions);
    const page = await browser.newPage();
    
    console.log('Opening page...');
    await page.goto(url, { waitUntil: 'networkidle2' });
    console.log('Page loaded!');

    const title = await page.title();
    console.log(`Page title: ${title}`);
    
    let mainHeading = '';
    try {
      mainHeading = await page.evaluate(() => {
        const h1El = document.querySelector('h1');
        return h1El ? h1El.innerText : '';
      });
    } catch (err) {
      console.log('No h1 found or error getting heading');
    }

    let metaDesc = '';
    try {
      metaDesc = await page.evaluate(() => {
        const metaEl = document.querySelector('meta[name="description"]');
        return metaEl ? metaEl.getAttribute('content') : '';
      });
    } catch (err) {
      console.log('No meta description found');
    }

    // Extract some links - limit to 10 to keep it manageable
    let pageLinks = [];
    try {
      pageLinks = await page.evaluate(() => {
        const linkElements = Array.from(document.querySelectorAll('a')).slice(0, 10);
        
        return linkElements.map(link => ({
          text: link.innerText.trim(),
          href: link.href
        })).filter(link => link.text && link.href);
      });
    } catch (err) {
      console.log('Error extracting links:', err.message);
    }

    const scrapedData = {
      url,
      title,
      heading: mainHeading,
      description: metaDesc,
      links: pageLinks,
      scrapedAt: new Date().toISOString()
    };

    fs.writeFileSync('/app/scraped_data.json', JSON.stringify(scrapedData, null, 2));
    console.log('✓ Data scraped and saved to scraped_data.json');
  } catch (error) {
    console.error('Oops! Error during scraping:', error.message);
    
    const errorData = {
      error: error.message,
      stack: error.stack,
      scrapedAt: new Date().toISOString()
    };
    
    fs.writeFileSync('/app/scraped_data.json', JSON.stringify(errorData, null, 2));
  } finally {
    if (browser) {
      await browser.close();
      console.log('Browser closed');
    }
  }
}

scrapeWebsite().catch(err => {
  console.error('Uncaught error:', err);
  process.exit(1);
}); 