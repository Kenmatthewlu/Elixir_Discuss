defmodule Discuss.TopicController do
    use Discuss.Web, :controller # Defines how a file should act 
    
    alias Discuss.Topic 

    def index(conn, _params) do
        # IO.inspect(conn.assigns.user)
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics #Passes keyword list
    end

    def new(conn, _params) do
        # struct = %Topic{}
        # params = %{}
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset #When conn is rendered, passes keywordlist changeset
    end

    def create(conn, %{"topic" => topic}) do
        # IO.inspect(params)
        changeset = Topic.changeset(%Topic{}, topic)
        case Repo.insert(changeset) do
            {:ok, _topic} -> #IO.inspect(topic)
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> #IO.inspect(changeset)
                render conn, "new.html", changeset: changeset
        end

    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id) #Table name, id, gets the entire row
        changeset = Topic.changeset(topic) #topic is a struct, there's only one argument since params has a default value of %{}

        render conn, "edit.html", changeset: changeset, topic: topic #changeset is where the changes to the database records are going to happen, topic is the one where the data on said row is viewed and to generate a correct path for the update function
    end

    def update(conn, %{"topic" => topic, "id" => topic_id }) do
        # IO.inspect(topic)
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)
        # changeset = Repo.get(Topic, topic_id)
        # |> Topic.changeset(topic)


        case Repo.update(changeset) do
            {:ok, _topic} ->
                # IO.inspect(topic)
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "edit.html", changeset: changeset, topic: old_topic
        end
        
    end

    def delete(conn, %{"id" => topic_id}) do
        Repo.get!(Topic, topic_id) |> Repo.delete!

        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: topic_path(conn, :index))
    end
end