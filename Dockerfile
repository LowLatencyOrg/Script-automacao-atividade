FROM node:20-alpine
WORKDIR
COPY . .
RUN npm install
EXPOSE 3333
CMD ["npm", "start"]
