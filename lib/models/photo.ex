defmodule Profiles.Photo do
  use Ecto.Schema

  @primary_key {:PhotoId, :id, autogenerate: true}
#  @derive {Poison.Encoder, only: [:name, :age]}
  schema "Photo" do
    field :ProfileId, :integer
    field :Url, :string
  end
end