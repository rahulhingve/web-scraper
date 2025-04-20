#!/bin/bash
set -e

DEFAULT_URL="https://rahulhingve.pro"
SCRAPE_URL=${SCRAPE_URL:-$DEFAULT_URL}

echo "================================================="
echo "  Web Scraper & Server"
echo "================================================="
echo " Target URL: $SCRAPE_URL"
echo " Started at: $(date)"
echo "================================================="

mkdir -p /app/data

echo " Starting web scraper..."
if node scrape.js; then
    echo " Scraping completed successfully!"
else
    echo "  Warning: Scraper exited with code $?. Will attempt to continue..."
    [ -f /app/scraped_data.json ] || echo '{"error": "Scraping failed", "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"}' > /app/scraped_data.json
fi

echo " Starting web server..."
echo " Access the data at http://localhost:5000"
echo "================================================="

exec python server.py 