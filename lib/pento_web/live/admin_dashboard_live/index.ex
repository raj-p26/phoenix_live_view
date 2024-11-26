defmodule PentoWeb.AdminDashboardLive.Index do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyResultsLive

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :survey_results_id, "survey-results")}
  end
end
