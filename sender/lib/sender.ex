defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, "email sent"}
  end
end
