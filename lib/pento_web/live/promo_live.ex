defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_recipient()
      |> assign_changeset()

    {:ok, socket}
  end

  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient(recipient_params)

    {:noreply, assign(socket, :changeset, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    :timer.sleep(1000)
    Promo.send_promo(socket.assigns.recipient, recipient_params)

    {:noreply, put_flash(socket, :info, "Message sent")}
  end

  defp assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign_new(:changeset, fn -> to_form(Promo.change_recipient(recipient)) end)
  end
end
