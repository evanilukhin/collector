defmodule CollectorWeb.HerdOfGophersChannel do
  use Phoenix.Channel

  def join("herd_of_gophers:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("herd_of_gophers:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("update_graph", %{"body" => body}, socket) do
    broadcast! socket, "update_graph", %{body: body}
    {:noreply, socket}
  end
end
