defmodule SendServer do
  use GenServer

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(opts) do
    max_retries = Keyword.get(opts, :max_retries, 5)
    state = %{emails: [], max_retries: max_retries}
    {:ok, state}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast({:send, email}, state) do
    Sender.send_email(email)
    emails = [%{email: email, status: "sent", retries: 0} | state.emails]
    {:noreply, %{state | emails: emails}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
