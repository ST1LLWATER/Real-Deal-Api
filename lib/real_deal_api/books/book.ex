defmodule RealDealApi.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :cover, :string
    field :review, {:array, :string}
    field :synopsis, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :cover, :synopsis, :review])
    |> validate_required([:title, :cover, :synopsis, :review])
  end
end
