defmodule ModMixedMessages do
  use Ejabberd.Module
  require DevNull
  require Sad
  require Happy
  require Scream
  require Leet
  require Silence
  require Sieve

  @transforms_list [DevNull, Sad, Happy, Scream, Leet, Silence, Sieve]
  @transforms_map Map.new(@transforms_list, fn t -> {t.name(), t} end)

  def start(_host, _opts) do
    host = :ejabberd_config.get_myname()
    conference_host = "conference.#{host}"

    @transforms_list
    |> Enum.map(fn room ->
      name = room.name()
      IO.puts(name)

      try do
        :mod_muc_admin.destroy_room(name, conference_host)
      catch
        _ ->
          IO.puts("failed to delete room")
      end

      try do
        :mod_muc_admin.create_room_with_opts(name, conference_host, host, [
          {"title", name},
          {"description", name}
        ])
      catch
        _ ->
          IO.puts("failed to create room")
      end
    end)

    :ejabberd_hooks.add(:filter_packet, &filter_packet/1, 50)
    :ok
  end

  def stop(_host) do
    :ejabberd_hooks.delete(:filter_packet, &filter_packet/1, 50)
    :ok
  end

  def filter_packet(packet) do
    case packet do
      {:message, client, :groupchat, lang, from, to, subject, [{:text, x, msgtext}], thread,
       subels, meta} ->
        case from do
          {:jid, sender, _, _, _, _, _} ->
            if Map.has_key?(@transforms_map, sender) do
              new_body = [{:text, x, @transforms_map[sender].transform(msgtext)}]

              {:message, client, :groupchat, lang, from, to, subject, new_body, thread, subels,
               meta}
            else
              packet
            end

          _ ->
            packet
        end

      {:message, _client, _type, _lang, _foo, _to, _subject, body, _thread, _sub_els, _meta} ->
        IO.inspect(body, label: "body")
        packet

      packet ->
        packet
    end
  end

  def depends(_host, _opts) do
    [{:mod_muc, :hard}]
  end

  def mod_options(_host) do
    []
  end

  def mod_doc() do
    %{:desc => "This is art."}
  end
end
