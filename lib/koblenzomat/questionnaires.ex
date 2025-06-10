defmodule Koblenzomat.Questionnaires do
  @moduledoc """
  Context for Questionnaires, Theses, Hashtags, and their associations.
  """

  alias Koblenzomat.{Repo, Thesis}
  import Ecto.Query

  def create_thesis(attrs) do
    position =
      case Map.get(attrs, :position) do
        nil ->
          _questionnaire_id = Map.fetch!(attrs, :questionnaire_id)
          max =
            Repo.one(
              from(t in Thesis,
                where: t.questionnaire_id == ^attrs[:questionnaire_id],
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
end
