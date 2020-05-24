defmodule Profiles.Profile do
  use Ecto.Schema

  @primary_key {:ProfileId, :id, autogenerate: true}
#  @derive {Poison.Encoder, only: [:name, :age]}
  schema "Profile" do
    field :AccountId, :integer
    field :Name, :string
    field :ProfileType, :string
    field :Description, :string
  end

end