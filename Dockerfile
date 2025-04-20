
FROM node:18-slim AS scraper


WORKDIR /app


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-symbola \
    fonts-noto \
    fonts-freefont-ttf \
    ca-certificates \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Installed Chromium version: $(chromium --version)"


ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium


COPY package.json ./
RUN npm install && \
    echo "Installed Node.js packages:" && \
    npm list --depth=0


COPY scrape.js ./



FROM python:3.10-slim


LABEL maintainer="rahul"
LABEL description="Web scraper with Puppeteer and Flask server"
LABEL version="1.0"


WORKDIR /app


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-symbola \
    fonts-noto \
    fonts-freefont-ttf \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Installed Node.js: $(node -v)" \
    && echo "Installed npm: $(npm -v)" \
    && echo "Installed Chromium: $(chromium --version)"


ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PYTHONUNBUFFERED=1 \
    PORT=5000


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt && \
    echo "Installed Python packages:" && \
    pip freeze


COPY --from=scraper /app/node_modules ./node_modules
COPY package.json ./
COPY scrape.js ./


COPY server.py ./
COPY run.sh ./
RUN chmod +x run.sh


RUN mkdir -p /app/data


EXPOSE 5000


ENTRYPOINT ["./run.sh"] 