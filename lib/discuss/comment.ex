defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :conent, :string
    belongs_to :topic, Discuss.Topic
    belongs_to :user, Discuss.User
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end

end
