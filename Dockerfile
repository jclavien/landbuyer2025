# --- BUILD STAGE ---
ARG ELIXIR_VERSION=1.15.8
ARG OTP_VERSION=25.3.2.21
ARG DEBIAN_VERSION=buster-20240612-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} AS builder

# Install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Set environment
ENV MIX_ENV=prod

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mkdir config

# Copy config files
COPY config/config.exs config/prod.exs config/
RUN mix deps.compile

# Copy source code
COPY lib lib
COPY priv priv
COPY assets assets

# Deploy assets and compile project
RUN mix assets.deploy
RUN mix compile

# Copy runtime config
COPY config/runtime.exs config/
COPY priv priv
COPY priv/repo priv/repo
COPY lib lib
COPY assets assets

# Build the release
RUN mix release

# --- RUN STAGE ---
FROM ${RUNNER_IMAGE}

# Install runtime dependencies
RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app
USER nobody

ENV MIX_ENV=prod

# Copy release from builder
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/landbuyer2025 /app/

# Launch the app
CMD ["/app/bin/landbuyer2025", "start"]

# Fly.io runtime settings
ENV ECTO_IPV6=true
ENV ERL_AFLAGS="-proto_dist inet6_tcp"
