FROM docker.io/elixir:1.14.2-slim AS builder
WORKDIR /app

ENV MIX_ENV=prod

COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

RUN mix compile
RUN mix release

FROM docker.io/elixir:1.14.2-slim

ARG PORT=4200
ENV PORT=${PORT}

COPY --from=builder /app/_build/prod/rel/me /opt/me
COPY --from=builder /app/www /opt/www

EXPOSE ${PORT}

ENTRYPOINT [ "/opt/me/bin/me", "start" ]
