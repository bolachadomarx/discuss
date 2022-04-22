defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Repo
  alias Discuss.Topic
  alias Discuss.Comment


  @impl true
  def join("comments:" <> topic_id, _payload, socket) do

    topic_id = String.to_integer(topic_id)
    topic = Topic
    |> Repo.get(topic_id)
    |> Repo.preload(comments: [:user])

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user
    changeset = topic
    |> Ecto.build_assoc(:comments, user_id: user_id)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
