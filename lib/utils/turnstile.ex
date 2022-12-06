defmodule Utils.Turnstile do
  def verify?(token) do
    secret = Application.get_env(:me, :captcha_secret)

    case HTTPoison.post(
           "https://challenges.cloudflare.com/turnstile/v0/siteverify",
           "response=#{token}&secret=#{secret}",
           [{"Content-Type", "application/x-www-form-urlencoded"}]
         ) do
      {:ok, response} ->
        Jason.decode!(response.body)["success"]

      {:error, _} ->
        false
    end
  end
end
