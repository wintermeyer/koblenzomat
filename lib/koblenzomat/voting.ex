defmodule Koblenzomat.Voting do
  @moduledoc """
  The Voting context is responsible for all business logic related to elections, theses (questions/statements), hashtags, and their associations.

  This context provides functions to create theses (with automatic position handling) and to list elections with their associated theses and hashtags. It acts as the main entry point for election-related operations in the application.
  """

  alias Koblenzomat.{Repo, Thesis, Election}
  import Ecto.Query

  @doc """
  Creates a thesis for a given election. If no position is provided, it will automatically assign the next available position within the election.

  ## Parameters
    - attrs: a map with thesis attributes, including :name, :election_id, and optionally :position

  ## Returns
    - {:ok, %Thesis{}} on success
    - {:error, %Ecto.Changeset{}} on failure
  """
  def create_thesis(attrs) do
    position =
      case Map.get(attrs, :position) do
        nil ->
          _election_id = Map.fetch!(attrs, :election_id)

          max =
            Repo.one(
              from(t in Thesis,
                where: t.election_id == ^attrs[:election_id],
                select: max(t.position)
              )
            ) || 0

          max + 1

        pos ->
          pos
      end

    attrs = Map.put(attrs, :position, position)

    %Thesis{}
    |> Thesis.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a list of all elections, each preloaded with their associated theses and hashtags.

  ## Returns
    - A list of %Election{} structs, each with a :theses field containing associated theses (and their hashtags)
  """
  def list_elections_with_theses do
    Repo.all(from e in Election, order_by: e.id, preload: [theses: [:hashtags]])
  end
end
