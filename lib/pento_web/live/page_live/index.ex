defmodule PentoWeb.PageLive.Index do
  use PentoWeb, :live_view

  alias Pento.Live
  alias Pento.Live.Page

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :results, Live.list_results())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Page")
    |> assign(:page, Live.get_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Page")
    |> assign(:page, %Page{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Results")
    |> assign(:page, nil)
  end

  @impl true
  def handle_info({PentoWeb.PageLive.FormComponent, {:saved, page}}, socket) do
    {:noreply, stream_insert(socket, :results, page)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    page = Live.get_page!(id)
    {:ok, _} = Live.delete_page(page)

    {:noreply, stream_delete(socket, :results, page)}
  end
end
