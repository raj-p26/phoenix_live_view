defmodule PentoWeb.RatingLive.ShowComponent do
  use PentoWeb, :live_component

  def render(assigns) do
    ~H"""
    <h4>
      <%= @product.name %> <%= raw(render_rating_stars(@rating.stars)) %>
    </h4>
    """
  end

  defp render_rating_stars(stars) do
    filled_stars(stars)
    |> Enum.concat(unfilled_stars(stars))
    |> Enum.join(" ")
  end

  defp filled_stars(stars) do
    List.duplicate("<span class='hero-star-solid bg-yellow-400'></span>", stars)
  end

  defp unfilled_stars(stars) do
    List.duplicate("<span class='hero-star'></span>", 5 - stars)
  end
end
