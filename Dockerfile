FROM node:10.13.0-alpine as app-build

WORKDIR /usr/src/app

RUN apk update && apk upgrade && \
  npm install -g yarn@1.12.x && rm -rf package-lock.json

COPY . ./
RUN yarn
RUN yarn build


FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=app-build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
