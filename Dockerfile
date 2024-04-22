FROM node:21-alpine3.18

EXPOSE 3000

RUN mkdir -p /home/webApp

COPY . /home/webApp

WORKDIR /home/webApp

RUN npm install -g npm

CMD ["node","task_completed.js"]

