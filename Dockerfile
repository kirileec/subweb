# ---- Dependencies ----
    FROM node:18-alpine3.20 AS build
    WORKDIR /app
    COPY . .
    RUN npm install
    RUN npm build
    
    FROM nginx:mainline-alpine
    COPY --from=build /app/dist /usr/share/nginx/html
    EXPOSE 80
    CMD [ "nginx", "-g", "daemon off;" ]
    