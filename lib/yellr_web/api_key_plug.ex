defmodule YellrWeb.ApiKeyPlug do
  import Plug.Conn

  def init(_) do
    get_api_key()
  end

  def call(conn, api_key_from_config) do
    api_key_from_config || raise "expected the API_KEY environment variable to be set"
    header_key_val = get_req_header(conn, "X-API-Key")
    param_key_val = Map.get(fetch_query_params(conn).query_params, "X-API-Key", nil)
    keys = (header_key_val ++ [param_key_val])
    has_api_key = Enum.member?(keys, api_key_from_config)
    case has_api_key do
      false ->
        conn
        |> send_resp(403, "Access Denied")
        |> halt()
      _ -> conn
    end
  end

  if (Mix.env == :prod) do
    defp get_api_key do
      System.get_env("API_KEY")
    end
  else
    defp get_api_key do
      "TESTKEY"
    end
  end
end
