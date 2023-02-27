defmodule RealDealApiWeb.BookView do
  use RealDealApiWeb, :view
  alias RealDealApiWeb.BookView

  def render("index.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{
      id: book.id,
      title: book.title,
      cover: book.cover,
      synopsis: book.synopsis,
      review: book.review
    }
  end
end
