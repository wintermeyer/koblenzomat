defmodule Koblenzomat.QuestionnairesTest do
  use Koblenzomat.DataCase
  alias Koblenzomat.{Questionnaire, Thesis, Hashtag, HashtagsToTheses}

  describe "questionnaire schema" do
    test "valid changeset" do
      changeset = Questionnaire.changeset(%Questionnaire{}, %{name: "Q1"})
      assert changeset.valid?
    end
  end

  describe "thesis schema" do
    test "valid changeset" do
      questionnaire = %Koblenzomat.Questionnaire{id: Ecto.UUID.generate(), name: "Q1"}

      changeset =
        Thesis.changeset(%Thesis{}, %{name: "T1", position: 1, questionnaire_id: questionnaire.id})

      assert changeset.valid?
    end
  end

  describe "hashtag schema" do
    test "valid changeset" do
      changeset = Hashtag.changeset(%Hashtag{}, %{name: "H1"})
      assert changeset.valid?
    end
  end

  describe "hashtags_to_theses schema" do
    test "valid changeset" do
      changeset = HashtagsToTheses.changeset(%HashtagsToTheses{}, %{name: "HT1"})
      assert changeset.valid?
    end
  end

  describe "thesis position uniqueness and requirements" do
    setup do
      questionnaire = Koblenzomat.Repo.insert!(%Koblenzomat.Questionnaire{name: "Q1"})
      %{questionnaire: questionnaire}
    end

    test "position is required", %{questionnaire: questionnaire} do
      changeset = Thesis.changeset(%Thesis{}, %{name: "T1", questionnaire_id: questionnaire.id})
      refute changeset.valid?
      assert {:position, {"can't be blank", [validation: :required]}} in changeset.errors
    end

    test "position is unique within questionnaire", %{questionnaire: questionnaire} do
      attrs = %{name: "T1", position: 1, questionnaire_id: questionnaire.id}
      changeset1 = Thesis.changeset(%Thesis{}, attrs)
      {:ok, _} = Koblenzomat.Repo.insert(changeset1)

      changeset2 =
        Thesis.changeset(%Thesis{}, %{name: "T2", position: 1, questionnaire_id: questionnaire.id})

      {:error, changeset2} = Koblenzomat.Repo.insert(changeset2)

      assert {:position,
              {"has already been taken",
               [constraint: :unique, constraint_name: "theses_questionnaire_id_position_index"]}} in changeset2.errors
    end
  end

  describe "thesis auto-increment position" do
    test "auto-increments position within questionnaire" do
      questionnaire = Koblenzomat.Repo.insert!(%Koblenzomat.Questionnaire{name: "QAuto"})
      attrs = %{name: "T1", questionnaire_id: questionnaire.id}
      {:ok, thesis1} = Koblenzomat.Questionnaires.create_thesis(attrs)

      {:ok, thesis2} =
        Koblenzomat.Questionnaires.create_thesis(%{
          name: "T2",
          questionnaire_id: questionnaire.id
        })

      assert thesis1.position == 1
      assert thesis2.position == 2
    end
  end
end
