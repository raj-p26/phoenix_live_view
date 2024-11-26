defmodule PentoWeb.RatingLive.IndexComponent do
  use PentoWeb, :live_component
  alias PentoWeb.RatingLive

  def render(assigns) do
    ~H"""
    <div class="mt-6">
      <h2 class="text-2xl">
        Ratings
        <%= if ratings_complete?(@products) do %>
          <.icon name="hero-check-circle-solid" />
        <% end %>
      </h2>
       <hr class="my-2 border" />
      <%= for {product, index} <- Enum.with_index(@products) do %>
        <%= if rating = List.first(product.ratings) do %>
          <.live_component
            id={"show-rating-#{index}"}
            module={RatingLive.ShowComponent}
            rating={rating}
            product={product}
          />
        <% else %>
          <.live_component
            id={"form-rating-#{product.id}"}
            module={RatingLive.FormComponent}
            product={product}
            product_index={index}
            user={@user}
          />
        <% end %>
      <% end %>
    </div>
    """
  end

  defp ratings_complete?(products) do
    Enum.all?(products, fn product ->
      length(product.ratings) == 1
    end)
  end
end
