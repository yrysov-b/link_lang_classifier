defmodule LinkLangClassifierWeb.ClassifierLive.Index do
  use LinkLangClassifierWeb, :live_view
  alias LinkLangClassifier.Finch, as: MyFinch

  @impl true
  def mount(_params, _session, socket) do
    result = get_next_link() |> IO.inspect
    {:ok, assign(socket, link: result), layout: false}
  end

  @spec get_next_link :: nil
  def get_next_link() do
    # 1. Get next link from DB
    with %LinkLangClassifier.Links.Link{} = link <- LinkLangClassifier.Links.get_next_unclassified() do
      # 2. Fetch the html by url with Finch
      {:ok, %{body: html}} = Finch.build(:get, link.url)
      |> Finch.request(MyFinch)
      # 3. Parse HTML and get required tags
      {:ok, required_tags} = parse_html(html)
      all_tags = Floki.find(required_tags, "meta")
      # 4. Put the required fields to a map and return
      all_tags
      |> Enum.map(fn {_, list,  _} -> list end)
      |> Enum.filter(fn [{name, _} | _] -> name == "property" end)
      |> Enum.reduce(%{id: link.id, url: link.url}, &property_reducer/2)
    end
  end

  defp parse_html(html) do
    Floki.parse_document(html)
  end

  defp property_reducer(list, acc) do
    {_, p_name} = hd list
    [{"content", val} | _] = tl list
    case p_name do
      "og:title" -> Map.put(acc, :title, val)
      "og:description" -> Map.put(acc, :desc, val)
      "og:video:url" -> Map.put(acc, :video, val)
      _ -> acc
    end
  end

  @impl true
  def handle_event("btn-event", %{"lang" => lang, "id"=> id}, socket) do
    {id, _} = Integer.parse(id)
    id
    |> LinkLangClassifier.Links.classify(lang)

    result = get_next_link()

    {:ok, assign(socket, link: result)}
  end
end
