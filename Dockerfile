FROM ruby:2.6-alpine3.11 as builder

RUN set -eux; \
    apk add --no-cache --virtual \
    # required
    nodejs yarn \
    # nice to haves
    vim curl git \
    # Fixes watch file isses with things like HMR
    libnotify-dev \
    # fixes timezone issues
    tzdata

FROM builder as bridgetownrb-app

# This is to fix an issue on Linux with permissions issues
# ARG USER_ID=${USER_ID:-1000}
# ARG GROUP_ID=${GROUP_ID:-1000}
# ARG USERNAME=${USERNAME:-user}
# ARG APP_DIR=${APP_DIR:-/home/$USER/bridgetown-app}

ARG USER_ID=$USER_ID
ARG GROUP_ID=$GROUP_ID
ARG DOCKER_USER=$DOCKER_USER
ARG APP_DIR=$APP_DIR

# Create a non-root user
RUN groupadd --gid $GROUP_ID $USERNAME
RUN useradd --no-log-init --uid $USER_ID --gid $GROUP_ID $USERNAME --create-home

# Create and then own the directory to fix permissions issues
RUN mkdir -p $APP_DIR
RUN chown -R $USER_ID:$GROUP_ID $APP_DIR

# Define the user running the container
USER $USER_ID:$GROUP_ID

# . now == $APP_DIR
WORKDIR $APP_DIR

# COPY is run as a root user, not as the USER defined above, so we must chown it
COPY --chown=$USER_ID:$GROUP_ID Gemfile* $APP_DIR/
RUN gem install bundler
RUN bundle install

# For webpacker / node_modules
# COPY --chown=$USER_ID:$GROUP_ID package.json $APP_DIR
# COPY --chown=$USER_ID:$GROUP_ID yarn.lock $APP_DIR

# RUN yarn install

CMD ["yarn", "start"]
