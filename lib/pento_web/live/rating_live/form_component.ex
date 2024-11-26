defmodule PentoWeb.RatingLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def render(assigns) do
    ~H"""
    <div class="transition border-2 border-slate-900 shadow-md hover:shadow-lg rounded p-4 my-4">
      <section>
        <h4><%= @product.name %></h4>
      </section>
      
      <section>
        <.simple_form for={@changeset} phx-submit="save" phx-change="validate" phx-target={@myself}>
          <.input
            field={@changeset[:stars]}
            type="select"
            options={Enum.reverse(1..5)}
            label="Stars:"
          /> <.input type="hidden" field={@changeset[:user_id]} />
          <.input type="hidden" field={@changeset[:product_id]} />
          <:actions>
            <.button phx-disable-with="Saving...">Save</.button>
          </:actions>
        </.simple_form>
      </section>
    </div>
    """
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_rating()
      |> assign_changeset()

    {:ok, socket}
  end

  def handle_event("validate", params, socket) do
    {:noreply, validate_rating(socket, params["rating"])}
  end

  def handle_event("save", params, socket) do
    {:noreply, save_rating(socket, params["rating"])}
  end

  defp validate_rating(socket, rating_params) do
    changeset =
      socket.assigns.rating
      |> Survey.change_rating(rating_params)

    assign(socket, changeset: to_form(changeset, action: :validate))
  end

  defp save_rating(
         %{assigns: %{product_index: product_index, product: product}} = socket,
         rating_params
       ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: to_form(changeset, action: :validate))
    end
  end

  defp assign_rating(%{assigns: %{user: user, product: product}} = socket) do
    rating = %Rating{
      user_id: user.id,
      product_id: product.id
    }

    assign(socket, :rating, rating)
  end

  defp assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, changeset: to_form(Survey.change_rating(rating)))
  end
end
