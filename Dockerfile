FROM buildpack-deps:zesty

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
  && wget -q https://bazel.build/bazel-release.pub.gpg -O- | apt-key add - \
  && apt-get update \
  && apt-get install bazel xz-utils -y \
  && apt-get upgrade bazel -y

ENV NPM_CONFIG_LOGLEVEL info
ARG NODE_VERSION=7.10.0
ARG YARN_VERSION=0.25.3

RUN curl -SLO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
  && tar -xJf "node-v${NODE_VERSION}-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v${NODE_VERSION}-linux-x64.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN  curl -fSL -o yarn.js "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-legacy-${YARN_VERSION}.js" \
  && curl -fSL -o yarn.js.asc "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-legacy-${YARN_VERSION}.js.asc" \
  && rm yarn.js.asc \
  && mv yarn.js /usr/local/bin/yarn \
  && chmod +x /usr/local/bin/yarn

RUN yarn init -y \
  && yarn global add express-generator@4.15.0 --prefix /usr/local \
  && yarn global add webpack-cli@1.3.3 --prefix /usr/local \
  && yarn global add create-react-app@1.3.1 --prefix /usr/local \
  && yarn global add vue-cli@v2.8.2 --prefix /usr/local \
  && yarn global add flow-typed@2.1.2 --prefix /usr/local

RUN apt-get autoremove \
  && apt-get autoclean
