defmodule PentoWeb.SurveyLive do
  alias Pento.Catalog
  alias Pento.Accounts
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias PentoWeb.Endpoint
  alias PentoWeb.RatingLive

  use PentoWeb, :live_view

  @survey_results_topic "survey_results"

  def mount(_params, %{"user_token" => user_token}, socket) do
    socket =
      socket
      |> assign_user(user_token)
      |> assign_demographic()
      |> assign_products()

    {:ok, socket}
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(user))
  end

  defp assign_products(socket) do
    user = socket.assigns.current_user

    assign(socket, :products, Catalog.list_products_with_user_ratings(user))
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, product, product_index)}
  end

  defp handle_rating_created(%{assigns: %{products: products}} = socket, product, product_idx) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating created successfully!")
    |> assign(:products, List.replace_at(products, product_idx, product))
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully!")
    |> assign(:demographic, demographic)
  end
end
