# SpiderFoot Dockerfile with fixed ENV format
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    nmap \
    dnsutils \
    whois \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/spiderfoot

# Clone SpiderFoot repository
RUN git clone https://github.com/smicallef/spiderfoot.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create data directory
RUN mkdir -p /var/lib/spiderfoot

# Set environment variables (using modern format)
ENV SPIDERFOOT_HOME=/var/lib/spiderfoot
ENV PYTHONPATH=/opt/spiderfoot
ENV SF_PORT=5001

# Expose port
EXPOSE 5001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python3 -c 'import urllib.request; urllib.request.urlopen("http://localhost:5001")' || exit 1

# Run SpiderFoot as root (simpler for permissions)
CMD ["python3", "sf.py", "-l", "0.0.0.0:5001"]
