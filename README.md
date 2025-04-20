#  Web Scraper & Content Host

A multi-container application that scrapes websites and serves the content. This project demonstrates how to:

1. Use Node.js with Puppeteer to scrape content from any website
2. Serve that content through a Python Flask web server
3. Package everything neatly in a single Docker container

##  Project Structure

```
.
├── 📄 Dockerfile       # Multi-stage build definition
├── 📄 scrape.js        # Node.js scraper using Puppeteer
├── 📄 server.py        # Python Flask server
├── 📄 run.sh           # Launch script
├── 📄 package.json     # Node.js dependencies
└── 📄 requirements.txt # Python dependencies
```



##  Getting Started

### Building the Image

```bash
# Clone this repo (if you haven't already)
git clone https://github.com/rahulhingve/web-scraper
cd web-scraper

# Build the Docker image
docker build -t web-scraper .
```

![docker build ](/images/dokcer%20build.png)

### Running the Container

```bash
# Basic usage - scrapes example.com
docker run -p 5000:5000 web-scraper

# Scrape a specific URL
docker run -p 5000:5000 -e SCRAPE_URL="https://rahulhingve.pro" web-scraper

# Use a different port and enable debug mode
docker run -p 8080:8080 -e PORT=8080 -e DEBUG=true \
  -e SCRAPE_URL="https://reddit.com" web-scraper
```
![running](/images/running-image.png)


## 🌐 Viewing the Results

Once the container is running:

1. Open your browser and go to `http://localhost:5000`
2. You'll see the scraped data in a nicely formatted JSON view
    ![main-page](/images/main-page.png)
3. For a health check, visit `http://localhost:5000/health`
    ![health](/images/health.png)

## 📋 What Gets Scraped

The scraper extracts:
- Page title
- First heading (H1)
- Meta description
- Up to 10 links with their text and URLs
- Timestamp when the scrape occurred

## 🐞 Troubleshooting

If you encounter issues:

- **Container won't start**: Make sure port 5000 is not in use by another application
- **Empty results**: Some sites use JavaScript to load content dynamically, which may not be fully captured
- **Permission errors**: The Docker user needs to have write permissions to create the JSON file

## 🚧 Future Improvements

Things I'd like to add:
- Support for authenticated scraping (cookies, login forms)
- Scheduled scraping with cron jobs
- More data extraction options
- A proper frontend UI

## 📄 License

Feel free to use, modify, and distribute! 