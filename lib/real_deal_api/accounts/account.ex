defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hashed_pass, :string
    has_one :user, RealDealApi.Users.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hashed_pass])
    |> validate_required([:email, :hashed_pass])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Enter a valid email")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{hashed_pass: hashed_pass}} = changeset
       ) do
    change(changeset, hashed_pass: Pbkdf2.hash_pwd_salt(hashed_pass))
  end

  defp put_pass_hash(changeset), do: changeset
end
