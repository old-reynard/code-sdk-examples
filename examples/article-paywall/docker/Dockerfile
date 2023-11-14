# Builder stage
FROM node:20-alpine AS builder

RUN apk update
RUN apk add --no-cache python3 make g++

COPY app app
WORKDIR /app
RUN npm install
RUN npx tsc

# Final stage
FROM node:20-alpine

RUN apk update && \
    apk add --no-cache

ENV NODE_PATH /usr/local/lib/node_modules
COPY --from=builder /app/node_modules /usr/local/lib/node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/articles ./articles
COPY --from=builder /app/public ./public
COPY --from=builder /app/views ./views
COPY --from=builder /app/.env ./.env

EXPOSE 3000

RUN apk add --no-cache curl
HEALTHCHECK --interval=15s --timeout=5s --start-period=20s --retries=3 CMD curl http://localhost:3000  || exit 1

# Start the application
CMD ["node", "./dist/app.js"]