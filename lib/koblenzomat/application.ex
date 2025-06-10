defmodule Koblenzomat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KoblenzomatWeb.Telemetry,
      Koblenzomat.Repo,
      {DNSCluster, query: Application.get_env(:koblenzomat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Koblenzomat.PubSub},
      # Start a worker by calling: Koblenzomat.Worker.start_link(arg)
      # {Koblenzomat.Worker, arg},
      # Start to serve requests, typically the last entry
      KoblenzomatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Koblenzomat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KoblenzomatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
