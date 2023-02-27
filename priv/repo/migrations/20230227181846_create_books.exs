defmodule RealDealApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :cover, :string
      add :synopsis, :text
      add :review, {:array, :text}

      timestamps()
    end
  end
end
