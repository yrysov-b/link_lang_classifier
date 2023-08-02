defmodule LinkLangClassifier.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias LinkLangClassifier.Links.Classification
  alias LinkLangClassifier.Repo

  alias LinkLangClassifier.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def get_next_unclassified(user_id) do
    Link
    |> join(:left, [l], c in Classification, on: c.link_id == l.id and c.classifier_id == ^user_id)
    |> where([l, c], is_nil(c.id))
    |> select([l,c], l)
    |> first()
    |> Repo.one()
  end

  def classify(id, lang, user_id) do
    %Classification{}
    |> Classification.changeset(%{"category" => lang, "classifier_id" => user_id, "link_id"=>id})
    |> Repo.insert()
  end

  @doc """
  Returns the total number of links.

  ## Examples

      iex> count_links()
      100

  """
  def count_links do
    length(Repo.all(Link))
  end 

  @doc """
  Returns the total number of classifications.

  ## Examples

      iex> count_classifications(user_id)
      70

  """
  def count_classifications(user_id) do
    query = from c in Classification, where: c.classifier_id == ^user_id
    length(Repo.all(query))
  end 

end

# from links as l
# left join classifications as c on l.id = c.link_Id and user_id = x
# where c.link_id is null
# limit 1
