defmodule PentoWeb.DemographicLive.ShowComponent do
  use PentoWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="transition border-2 border-slate-900 shadow-md hover:shadow-lg rounded p-4">
      <h3 class="text-2xl mb-4">
        Demographic<.icon name="hero-check-circle-solid ms-2 stroke-green-600" />
      </h3>
      
      <ul>
        <li>Year of Birth: <%= @demographic.year_of_birth %></li>
        
        <li>gender: <%= @demographic.gender %></li>
      </ul>
    </div>
    """
  end
end
