defmodule Pento.LiveFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Live` context.
  """

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        query: "some query"
      })
      |> Pento.Live.create_page()

    page
  end
end
