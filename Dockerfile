# ---- Dependencies ----
    FROM node:18-alpine3.20 AS build
    WORKDIR /app
    COPY . .
    RUN npm install
    RUN npm run build
    
    FROM nginx:mainline-alpine
    COPY --from=build /app/dist /usr/share/nginx/html
    ENV SUB_PROJECT="https://github.com/kirileec/subweb"
    ENV SUB_SUBCONVERTER_DEFAULT_BACKEND="https://sub.202816.xyz"
    ENV SUB_LOAD_REMOTE true
    ENV SUB_REMOTE_JSON="https://mirror.ghproxy.com/https://raw.githubusercontent.com/kirileec/sub-rules/main/config.json"
    ENV SUB_REMOTE_BACKENDJSON="https://mirror.ghproxy.com/https://raw.githubusercontent.com/kirileec/sub-rules/main/backend.json"
    EXPOSE 80
    CMD [ "nginx", "-g", "daemon off;" ]
    