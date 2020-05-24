defmodule Profiles.Preference do
  use Ecto.Schema

  @primary_key {:PreferenceId, :id, autogenerate: true}
#  @derive {Poison.Encoder, only: [:name, :age]}
  schema "Preferences" do
    field :ProfileId, :integer
    field :PreferenceText, :string
  end
end