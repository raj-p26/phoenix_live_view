defmodule PentoWeb.SurveyResultsLive.Index do
  use PentoWeb, :live_component
  use PentoWeb, :live_chart
  alias Pento.Catalog

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_age_group_filter()
      |> assign_products_with_avg_rating()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()

    {:ok, socket}
  end

  def handle_event("age_group_filter", %{"age_group_filter" => filter}, socket) do
    socket
    |> assign_age_group_filter(filter)
    |> assign_products_with_avg_rating()
    |> assign_dataset()
    |> assign_chart()
    |> assign_chart_svg()

    {:noreply, socket}
  end

  defp assign_age_group_filter(socket) do
    assign(socket, :age_group_filter, "all")
  end

  defp assign_age_group_filter(socket, filter) do
    assign(socket, :age_group_filter, filter)
  end

  defp assign_products_with_avg_rating(%{assigns: %{age_group_filter: filter}} = socket) do
    socket
    |> assign(
      :products_with_avg_rating,
      products_with_avg_rating(%{age_group_filter: filter})
    )
  end

  defp products_with_avg_rating(filter) do
    case Catalog.products_with_avg_rating(filter) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  defp assign_dataset(socket) do
    %{assigns: %{products_with_avg_rating: product_with_avg_rating}} = socket

    assign(socket, :dataset, make_dataset(product_with_avg_rating))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    assign(socket, :chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    assign(socket, :chart_svg, render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis()))
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "avarage star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"
end
