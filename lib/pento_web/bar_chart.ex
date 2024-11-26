defmodule PentoWeb.BarChart do
  alias Contex.{Dataset, BarChart, Plot}

  def make_dataset(data) do
    Dataset.new(data)
  end

  def make_bar_chart(dataset) do
    BarChart.new(dataset)
  end

  def render_bar_chart(chart, title, subtitle, x_label, y_label) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title, subtitle)
    |> Plot.axis_labels(x_label, y_label)
    |> Plot.to_svg()
  end
end
