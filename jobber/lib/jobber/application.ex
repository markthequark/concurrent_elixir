defmodule Jobber.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    job_runner_config = [
      strategy: :one_for_one,
      max_seconds: 30,
      name: Jobber.JobRunner
    ]

    children = [
      {Registry, keys: :unique, name: Jobber.JobRegistry},
      {DynamicSupervisor, job_runner_config}
    ]

    opts = [strategy: :one_for_one, name: Jobber.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
