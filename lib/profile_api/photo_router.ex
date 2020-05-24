defmodule Profiles.PhotoRouter do
  use Plug.Router
  use Timex
  alias Profiles.Photo
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
    photos =  Profiles.Repo.all(from d in Profiles.Photo, where: d."ProfileId" == ^profile_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(photos))
  end

  get "/get-all" do
    photos =  Profiles.Repo.all(from d in Profiles.Photo)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(photos))
  end

  post "/insert" do
    Logger.debug inspect(conn.body_params)

    {profile_id, url} = {
      Map.get(conn.body_params, "profile_id", nil),
      Map.get(conn.body_params, "url", nil),
    }
    cond do
      is_nil(profile_id) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'profile id' field must be provided"})
      is_nil(url) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{"error" => "'url' field must be provided"})
      true ->
        case %Profiles.Photo{
          ProfileId: profile_id,
          Url: url
        } |> Profiles.Repo.insert do
          {:ok, new_photo} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(%{:data => new_photo}))
          :error ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(507, Poison.encode!(%{"error" => "An unexpected error happened"}))

        end
    end
  end


  delete "/delete" do
      id = Map.get(conn.params, "id", nil)
      photo = Profiles.Repo.get(Profiles.Photo, id)

      case Profiles.Repo.delete photo do
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