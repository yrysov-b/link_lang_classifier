defmodule LinkLangClassifier.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :category, :string
    field :classified_by, :integer
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :category, :classified_by])
    |> validate_required([:url])
  end
end
