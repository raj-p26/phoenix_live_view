defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  def home(conn, _params) do
    path =
      if conn.assigns.current_user do
        "/guess"
      else
        "/users/log_in"
      end

    conn
    |> redirect(to: path)
  end
end
