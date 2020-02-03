defmodule YellrWeb.ApiKeyPlug do
  import Plug.Conn
  alias YellrWeb.Endpoint

  def init(_) do
    :ok
  end

  def call(conn, _) do
    api_key_from_config = Endpoint.config(:x_api_key)
    header_key_val = get_req_header(conn, "x-api-key")
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
end
