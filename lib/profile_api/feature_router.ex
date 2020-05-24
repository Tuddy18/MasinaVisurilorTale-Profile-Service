defmodule Profiles.FeatureRouter do
  use Plug.Router
  use Timex
  alias Profiles.Feature
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
    features =  Profiles.Repo.all(from d in Profiles.Feature, where: d."ProfileId" == ^profile_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(features))
  end

  get "/get-all" do
    features =  Profiles.Repo.all(from d in Profiles.Feature)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(features))
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
        case %Profiles.Feature{
          ProfileId: profile_id,
          FeatureText: text
        } |> Profiles.Repo.insert do
          {:ok, new_feature} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(%{:data => new_feature}))
          :error ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(507, Poison.encode!(%{"error" => "An unexpected error happened"}))

        end
    end
  end


  delete "/delete" do
      id = Map.get(conn.params, "id", nil)
      feature = Profiles.Repo.get(Profiles.Feature, id)

      case Profiles.Repo.delete feature do
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