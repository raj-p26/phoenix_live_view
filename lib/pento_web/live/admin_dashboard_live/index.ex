defmodule PentoWeb.AdminDashboardLive.Index do
  use PentoWeb, :live_view

  alias PentoWeb.Endpoint
  alias PentoWeb.SurveyResultsLive

  @survey_results_topic "survey_results"
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
    end

    {:ok, assign(socket, :survey_results_id, "survey-results")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive.Index, id: socket.assigns.survey_results_id)

    {:noreply, socket}
  end
end
