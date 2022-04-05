defmodule SendServer do
  use GenServer
  require Logger

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(opts) do
    max_retries = Keyword.get(opts, :max_retries, 5)
    state = %{emails: [], max_retries: max_retries}

    schedule_retry()
    {:ok, state}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast({:send, email}, state) do
    status = send_email(email)

    emails = [%{email: email, status: status, retries: 0} | state.emails]
    {:noreply, %{state | emails: emails}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(:retry, state) do
    emails =
      for email <- state.emails do
        if email.status == "failed" and email.retries < state.max_retries do
          Logger.info("Retrying email #{email.email}...")

          status = send_email(email.email)
          %{email | status: status, retries: email.retries + 1}
        else
          email
        end
      end

    schedule_retry()
    {:noreply, %{state | emails: emails}}
  end

  def terminate(reason, _state) do
    IO.puts("Terminating with reason #{reason}")
  end

  defp send_email(email) do
    case Sender.send_email(email) do
      {:ok, "email_sent"} -> "sent"
      :error -> "failed"
    end
  end

  defp schedule_retry(time \\ :timer.seconds(5)) do
    Process.send_after(self(), :retry, time)
  end
end
