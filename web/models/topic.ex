defmodule Discuss.Topic do
    use Discuss.Web, :model
    
    schema "topics" do
        field :title, :string
    end

    def changeset(struct, params \\ %{}) do # \\ is assigning a default value to argument list
        struct
        |> cast(params, [:title])
        |> validate_required([:title])
    end
end