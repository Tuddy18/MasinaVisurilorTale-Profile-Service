defmodule Profiles.PreferenceRouter do
  use Plug.Router
  use Timex
  alias Profiles.Preference
  import Ecto.Query
  #use Profiles.Auth
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
#  plug Profiles.AuthPlug
    plug CORSPlug, origin: "*"
  plug(:dispatch)



  get "/get-by-profile" do
    profile_id = Map.get(conn.params, "profile_id", nil)
    preferences =  Profiles.Repo.all(from d in Profiles.Preference, where: d."ProfileId" == ^profile_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(preferences))
  end

  get "/get-all" do
    preferences =  Profiles.Repo.all(from d in Profiles.Preference)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(preferences))
  end

  post "/insert" do
    Logger.debug inspect(conn.body_params)

    {profile_id, text} = {
      Map.get(conn.body_params, "profile_id", nil),
      Map.get(conn.body_params, "text", nil),
    }
    cond do
      is_nil(profile_id) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'profile id' field must be provided"})
      is_nil(text) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'text' field must be provided"})
      true ->
        case %Profiles.Preference{
          ProfileId: profile_id,
          PreferenceText: text
        } |> Profiles.Repo.insert do
          {:ok, new_preference} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(%{:data => new_preference}))
          :error ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(507, Poison.encode!(%{"error" => "An unexpected error happened"}))

        end
    end
  end


  delete "/delete" do
      id = Map.get(conn.params, "id", nil)
      preference = Profiles.Repo.get(Profiles.Preference, id)

      case Profiles.Repo.delete preference do
        {:ok, struct}       ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(%{:data => struct}))
        {:error, changeset} ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(507, Poison.encode!(%{"error" => "An unexpected error happened"}))
        end
  end



end