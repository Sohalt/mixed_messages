defmodule MessageTransformer do
  def make_transform(transform_fn) do
    fn packet = {:message, client, type, lang, from, to, subject, body, thread, sub_els, meta} ->
      case body do
        [{:text, x, msg_text}] ->
          new_body = [{:text, x, transform_fn.(msg_text)}]
          {:message, client, type, lang, from, to, subject, new_body, thread, sub_els, meta}

        _ ->
          packet
      end
    end
  end
end
