defmodule LinkLangClassifier.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :category, :string
      add :classified_by, :integer

      timestamps()
    end
  end
end
