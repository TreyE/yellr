defmodule GitData.GithubPat do
  @moduledoc """
  Middleware to add github PAT to requests.
  """
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _opts) do
    env
    |> put_github_auth_pat_if_set()
    |> Tesla.run(next)
  end

  defp put_github_auth_pat_if_set(env) do
    case read_system_env_for_github_api_token() do
      :none -> env
      {:token, token} ->
        Tesla.put_header(
          env,
          "Authorization",
          "token " <> token
        )
    end
  end

  defp read_system_env_for_github_api_token() do
    case System.get_env("GITHUB_API_PAT") do
      nil -> :none
      "" -> :none
      a -> {:token, a}
    end
  end
end
