defmodule ModMixedMessages do
  use Ejabberd.Module
  require MessageTransformer

  @rooms ["scream", "shuffle", "1337", "abyss", "happy", "sad"]

  def start(_host, _opts) do
    :ejabberd_hooks.add(:filter_packet, &filter_packet/1, 50)

    [host | _] = :ejabberd_config.get_option(:hosts, [])
    conference_host = "conference.#{host}"

    @rooms
    |> Enum.map(fn room ->
      IO.puts(room)

      try do
        :mod_muc_admin.destroy_room(room, conference_host)
      catch
        _ ->
          IO.puts("failed to delete room")
      end

      try do
        :mod_muc_admin.create_room_with_opts(room, conference_host, host, [
          {"title", room},
          {"description", room}
        ])
      catch
        _ ->
          IO.puts("failed to create room")
      end
    end)

    :ok
  end

  def stop(_host) do
    :ejabberd_hooks.delete(:filter_packet, &filter_packet/1, 50)
    :ok
  end

  def drop_all(_) do
    "😶"
  end

  defp leet_char(c) do
    case c do
      "a" -> "4"
      "e" -> "3"
      "l" -> "1"
      "o" -> "0"
      "s" -> "5"
      "t" -> "7"
      "z" -> "2"
      _ -> c
    end
  end

  def force_happy(msg) do
    if Afinn.score(msg, :en) > 0 do
      msg
    else
      "cheer up"
    end
  end

  def force_sad(msg) do
    if Afinn.score(msg, :en) > 0 do
      "more doom"
    else
      msg
    end
  end

  def leet_speak(msg) do
    String.downcase(msg) |> String.codepoints() |> Enum.map(&leet_char/1) |> Enum.join("")
  end

  def shuffle_words(sentence) do
    String.split(sentence, " ") |> Enum.shuffle() |> Enum.join(" ")
  end

  def shuffle_words_in_sentences(msg) do
    String.split(msg, ". " |> Enum.map(&shuffle_words/1) |> Enum.join(". "))
  end

  def filter_packet(packet) do
    scream = MessageTransformer.make_transform(&String.upcase/1)
    shuffle = MessageTransformer.make_transform(&ModMixedMessages.shuffle_words/1)
    leet = MessageTransformer.make_transform(&ModMixedMessages.leet_speak/1)
    abyss = MessageTransformer.make_transform(&ModMixedMessages.drop_all/1)
    happy = MessageTransformer.make_transform(&ModMixedMessages.force_happy/1)
    sad = MessageTransformer.make_transform(&ModMixedMessages.force_sad/1)

    case packet do
      {:message, _client, :groupchat, _lang, {:jid, "scream", _, _, _, _, _}, _to, _subject,
       _body, _thread, _sub_els, _meta} ->
        scream.(packet)

      {:message, _client, :groupchat, _lang, {:jid, "shuffle", _, _, _, _, _}, _to, _subject,
       _body, _thread, _sub_els, _meta} ->
        shuffle.(packet)

      {:message, _client, :groupchat, _lang, {:jid, "1337", _, _, _, _, _}, _to, _subject, _body,
       _thread, _sub_els, _meta} ->
        leet.(packet)

      {:message, _client, :groupchat, _lang, {:jid, "abyss", _, _, _, _, _}, _to, _subject, _body,
       _thread, _sub_els, _meta} ->
        abyss.(packet)

      {:message, _client, :groupchat, _lang, {:jid, "happy", _, _, _, _, _}, _to, _subject, _body,
       _thread, _sub_els, _meta} ->
        happy.(packet)

      {:message, _client, :groupchat, _lang, {:jid, "sad", _, _, _, _, _}, _to, _subject, _body,
       _thread, _sub_els, _meta} ->
        sad.(packet)

      {:message, _client, _type, _lang, _from, _to, _subject, body, _thread, _sub_els, _meta} ->
        IO.inspect(body, label: "body")
        packet

      _ ->
        IO.inspect(packet, label: "packet")
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
