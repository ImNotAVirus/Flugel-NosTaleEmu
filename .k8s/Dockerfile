FROM elixir:1.9.4-alpine AS builder

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache build-base git && \
    mix local.rebar --force && \
    mix local.hex --force

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}
WORKDIR /opt/app

# Get deps
COPY mix.exs .
COPY mix.lock .
COPY apps/database_service/mix.exs apps/database_service/
COPY apps/login_server/mix.exs apps/login_server/
COPY apps/session_manager/mix.exs apps/session_manager/
COPY apps/world_manager/mix.exs apps/world_manager/
COPY apps/world_server/mix.exs apps/world_server/
RUN mix do deps.get, deps.compile

# Copy app
COPY rel ./rel
COPY apps ./apps
COPY config ./config

# Create Mix release
ARG APP_NAME=flugel
RUN mix release ${APP_NAME}

#######################################################################

# Final image
FROM alpine:3.11

WORKDIR /opt/app

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache bash libstdc++ openssl
ARG APP_NAME=flugel
ENV APP_NAME=${APP_NAME}
COPY --from=builder /opt/app/_build/prod/rel/${APP_NAME} .
CMD ["sh", "-c", "./bin/${APP_NAME} start"]
