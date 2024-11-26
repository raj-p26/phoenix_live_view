defmodule PentoWeb.WrongLive.Index do
  use PentoWeb, :live_view
  alias Pento.Accounts

  @impl true
  def mount(_params, session, socket) do
    random = Enum.random(1..10)

    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        random: random,
        user: Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
    }
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, socket) do
    guess_int = String.to_integer(guess)

    {message, score} =
      if guess_int == socket.assigns.random do
        IO.inspect("Here")
        {"You win!", socket.assigns.score + 1}
      else
        IO.inspect("Impossible")
        {"Try again", socket.assigns.score}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score
      )
    }
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    if socket.assigns.live_action === :restart do
      random = Enum.random(1..10)
      {:noreply, assign(socket, random: random)}
    else
      {:noreply, socket}
    end
  end
end
