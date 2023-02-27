defmodule RealDealApi.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealDealApi.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        cover: "some cover",
        review: [],
        synopsis: "some synopsis",
        title: "some title"
      })
      |> RealDealApi.Books.create_book()

    book
  end
end
