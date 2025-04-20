#!/usr/bin/env python3

import os
import json
from datetime import datetime
from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Web Scraper Results</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; line-height: 1.6; }
        h1 { color: #333; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        pre { background: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto; }
        .container { max-width: 800px; margin: 0 auto; }
        .timestamp { color: #888; font-size: 0.8em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Scraped Data Results</h1>
        <p class="timestamp">Generated: {{ current_time }}</p>
        <pre>{{ json_data }}</pre>
    </div>
</body>
</html>
"""

@app.route('/')
def serve_scraped_data():
    """Main route to display the scraped data"""
    try:
        with open('scraped_data.json', 'r') as file:
            data = json.load(file)
        
        if request.headers.get('Accept') == 'application/json':
            return jsonify(data)
            
        return render_template_string(
            HTML_TEMPLATE,
            json_data=json.dumps(data, indent=4),
            current_time=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )
            
    except FileNotFoundError:
        return jsonify({
            "error": "No scraped data found",
            "message": "The scraper hasn't completed yet or failed to generate data"
        }), 404
    except json.JSONDecodeError:
        return jsonify({
            "error": "Invalid JSON data",
            "message": "The scraped data file contains invalid JSON"
        }), 500
    except Exception as e:
        return jsonify({
            "error": str(e),
            "message": "Failed to load scraped data"
        }), 500

@app.route('/health')
def health_check():
    """Simple health check endpoint"""
    return jsonify({"status": "healthy", "time": datetime.now().isoformat()}), 200

# Need to fix this later - missing import
from flask import request

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug_mode = os.environ.get('DEBUG', 'False').lower() == 'true'
    
    print(f"Starting server on port {port}, debug mode: {debug_mode}")
    
    app.run(host='0.0.0.0', port=port, debug=debug_mode) 