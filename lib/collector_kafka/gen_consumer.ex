defmodule CollectorKafka.GenConsumer do
  use KafkaEx.GenConsumer
  alias KafkaEx.Protocol.Fetch.Message
  require IEx

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    refined_messages_chunk =
      Enum.map(message_set, &refine_message/1)
    IO.inspect(refined_messages_chunk)
    CollectorWeb.Endpoint.broadcast("herd_of_gophers:lobby", "update_graph", %{body: refined_messages_chunk})
    {:async_commit, state}
  end

  defp refine_message(raw_message) do
    %Message{value: message} = raw_message

    collector =
      NaiveDateTime.utc_now
      |> NaiveDateTime.to_time
      |> Timex.Duration.from_time

    {:ok, decoded_message} = Poison.decode(message)
    created_at = calc_duration(decoded_message["created_at"])
    firebus = calc_duration(decoded_message["firebus"])
    herd_of_gophers = calc_duration(decoded_message["herd_of_gophers"])
    created_to_bus = Timex.Duration.diff(firebus, created_at, :microseconds)
    %{uuid: decoded_message["uuid"],
      created_to_bus: created_to_bus,
      created_to_collector: Timex.Duration.diff(collector, created_at, :microseconds),
      item: decoded_message["item"]}
  end

  defp calc_duration(time_string) do
    {:ok, time} = Timex.parse(time_string, "{h24}:{m}:{s}{ss}")
    NaiveDateTime.to_time(time) |> Timex.Duration.from_time
  end
end
