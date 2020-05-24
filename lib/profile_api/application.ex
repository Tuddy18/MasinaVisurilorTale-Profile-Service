defmodule Profiles.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
      :ets.new(:my_tokens, [:set, :public, :named_table])
      #{user_id, token}

      Supervisor.start_link(children(), opts())
  end
    defp children do
     [
     {Plug.Adapters.Cowboy2, scheme: :http,

     plug: Profiles.Endpoint, options: [ip: {0,0,0,0}, port: 4000]},
       {Profiles.Repo, [],},
#     {MyXQL, username: "root", hostname: "localhost", name: :myapp_db},
#     worker(Profiles.DB.Manager, [[
#       name: Profiles.DB.Manager,
#       host: Application.get_env(:profiles, :redb_host),
#       port: Application.get_env(:profiles, :redb_port)
#     ]]),
     ]
#     Profiles.DB.Manager.init_db(:redb, :redb_tables)

    end

  defp opts do
    [
      strategy: :one_for_one,
      name: Profiles.Supervisor
    ]

  end
end
