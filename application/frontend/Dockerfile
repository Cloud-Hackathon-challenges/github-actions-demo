# ---- build stage ----
    FROM node:16-alpine AS build
    WORKDIR /app
    
    COPY package*.json ./
    
    # normal dene, gerekirse TLS fallback
    RUN set -eux; \
        npm ci --no-audit --no-fund || ( \
          npm config set strict-ssl false; \
          npm config set registry http://registry.npmjs.org/; \
          npm install --no-audit --no-fund \
        )
    
    COPY . .
    ENV CI=false
    RUN npm run build
    
    # ---- run stage ----
    FROM nginx:stable-alpine
    COPY --from=build /app/build /usr/share/nginx/html
    COPY proxy/nginx.conf /etc/nginx/conf.d/default.conf
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
    # docker build -t frontend:1.0 .