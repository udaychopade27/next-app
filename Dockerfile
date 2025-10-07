# Use official Node.js image as the base
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies, copy only package files for caching
COPY package*.json ./
RUN npm i

# Copy rest of the files & build
COPY . .
RUN npm run build

# Production image
FROM node:18-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copy production build files
COPY --from=builder /app ./

EXPOSE 3000
CMD ["npm", "start"]
