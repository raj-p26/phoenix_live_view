defmodule Pento.Live.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "results" do
    field :query, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:query])
    |> validate_required([:query])
  end
end
