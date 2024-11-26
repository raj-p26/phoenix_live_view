defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@changeset} phx-target={@myself} phx-submit="save" id="demographic-form">
        <.input
          type="select"
          field={@changeset[:gender]}
          options={[male: "male", female: "female"]}
          label="Gender"
        />
        <.input
          type="select"
          field={@changeset[:year_of_birth]}
          options={Enum.reverse(1990..Date.utc_today().year)}
          label="Year of Birth"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    user = socket.assigns.user
    {:noreply, save_demographic(socket, Map.put(demographic_params, "user_id", user.id))}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> assign_changeset()

    {:ok, socket}
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: to_form(changeset, action: :validate))
    end
  end

  defp assign_demographic(%{assigns: assigns} = socket) do
    assign(socket, :demographic, %Demographic{user_id: assigns.user.id})
  end

  defp assign_changeset(%{assigns: assigns} = socket) do
    assign_new(socket, :changeset, fn ->
      to_form(Survey.change_demographic(assigns.demographic))
    end)
  end
end
