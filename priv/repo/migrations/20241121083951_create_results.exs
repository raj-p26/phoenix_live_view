defmodule Pento.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :query, :string

      timestamps(type: :utc_datetime)
    end
  end
end
