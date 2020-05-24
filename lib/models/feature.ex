defmodule Profiles.Feature do
  use Ecto.Schema

  @primary_key {:FeatureId, :id, autogenerate: true}
#  @derive {Poison.Encoder, only: [:name, :age]}
  schema "Features" do
    field :ProfileId, :integer
    field :FeatureText, :string
  end
end