FROM node:20-slim

# Install dependencies for audio processing if needed
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy source code
COPY . .

# Ensure output directory exists
RUN mkdir -p output

EXPOSE 8080

CMD [ "npm", "start" ]
