defmodule Profiles.AuthPlug do
  import Plug.Conn
  import HTTPotion
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
#     get_resp = HTTPotion.get "https://elixir-profile-service.azurewebsites.net/profile/get-all"
#     Logger.debug inspect(get_resp)

    #doar exemplu!
    #https://devhints.io/phoenix-conn
    auth_header = conn
                |> get_req_header("authorization")
                |> List.first()
        Logger.debug inspect(auth_header)

        case auth_header do
          nil ->
            send_resp(conn, 402, "No authorization token found!") |> halt
          raw_token ->
            token = raw_token
                      |> String.split(" ")
                      |> List.last()
                validate_url = Application.get_env(:profiles, :account_service_url) <> "/account/validate-token"
                token_body =  Poison.encode!(%{token: token})
                resp = HTTPotion.post  validate_url , [body: token_body, headers: ["Content-Type": "application/json"]]
                Logger.debug inspect(resp)

                status = resp.status_code()
                Logger.debug inspect(status)
                if status == 200 do
                    conn
                  else
                    conn |> forbidden
                end
        end
  end

  defp forbidden(conn) do
    send_resp(conn, 401, "Unauthorized!") |> halt
  end
end
