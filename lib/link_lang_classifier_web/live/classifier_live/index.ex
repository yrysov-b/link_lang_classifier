defmodule LinkLangClassifierWeb.ClassifierLive.Index do
  use LinkLangClassifierWeb, :live_view

  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def get_next_link() do
    # 1. Get next link from DB
    # 2. Fetch the html by url with Finch
    # 3. Parse HTML and get required tags
    # 4. Put the required fields to a map and return
  end
end
