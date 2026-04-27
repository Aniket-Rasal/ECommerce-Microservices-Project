# Multi-stage build — don't skip this, it matters for image size
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY src/ ./src/
COPY package.json .

EXPOSE 3000
USER node
CMD ["node", "src/index.js"]
