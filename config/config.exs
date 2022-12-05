import Config

config :me,
  mongo_url: System.get_env("MONGO_URL"),
  port: System.get_env("PORT")
