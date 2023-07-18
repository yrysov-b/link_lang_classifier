defmodule LinkLangClassifier.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      timestamps()
    end

    create table(:classifications) do
      add :classifier_id, references(:users)
      add :category, :string
      add :link_id, references(:links)
      #two foreign keys classifier_id (unique constraint) (references)
      timestamps()
    end

    create (
      unique_index(
        :classifications,
         [:classifier_id,:link_id]
        )
      )
  end
end
