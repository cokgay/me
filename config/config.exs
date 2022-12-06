import Config

config :me,
  mongo_url: System.get_env("MONGO_URL"),
  captcha_secret: System.get_env("CAPTCHA_SECRET"),
  port: System.get_env("PORT")
