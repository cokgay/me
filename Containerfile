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

COPY --from=builder /app/_build/prod/rel/me /release/me
COPY --from=builder /app/www /www

EXPOSE 4201

ENTRYPOINT [ "/release/me/bin/me", "start" ]
