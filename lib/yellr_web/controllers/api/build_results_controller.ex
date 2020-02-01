defmodule YellrWeb.Api.BuildResultsController do
  use YellrWeb, :controller

  def create(conn, params) do
    result = Yellr.report_result_from_params(params)
    case result do
      {:ok, _} ->
        conn
        |> send_resp(200, "")
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("error.json", %{changeset: changeset})
    end
  end
end
