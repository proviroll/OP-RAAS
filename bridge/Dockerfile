FROM node:20 

WORKDIR /app

RUN apt-get update && apt-get install -y sudo jq git
RUN npm install -g pnpm only-allow

ENV BRIDGE_REPO=https://github.com/aminechakr/op-bridge.git
ENV BRIDGE_BRANCH=main

RUN git clone $BRIDGE_REPO --depth 1 --branch $BRIDGE_BRANCH --single-branch . && \
    git switch -c branch-$BRIDGE_BRANCH && \
    yarn install && yarn build
