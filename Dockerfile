FROM elixir:1.6.4
ENV DEBIAN_FRONTEND=noninteractive

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

RUN mix do local.hex --force, local.rebar --force && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y -q nodejs php5 php5-readline php5-cli

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest && \
    mkdir -p /var/www/html/nps/prison_cms_files

#  USER default

CMD ["mix", "phx.server"]