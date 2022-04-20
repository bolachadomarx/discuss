defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Repo
  alias Discuss.Topic
  alias Discuss.Comment

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do

    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
    IO.inspect(topic)

    {:ok, assign(socket, :topic, topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(_name, %{"content" => content}, socket) do

    topic = socket.assigns.topic

    changeset = topic
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
    {:reply, :ok, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
