defmodule Koblenzomat.VotingTest do
  @moduledoc """
  Tests for the Voting context, covering election, thesis, hashtag, and their associations.

  These tests ensure that the core business logic for creating and validating elections and theses works as expected, including position uniqueness and auto-increment behavior.
  """
  use Koblenzomat.DataCase
  alias Koblenzomat.{Election, Thesis, Hashtag, HashtagsToTheses}

  describe "election schema" do
    test "valid changeset" do
      changeset = Election.changeset(%Election{}, %{name: "Q1"})
      assert changeset.valid?
    end
  end

  describe "thesis schema" do
    test "valid changeset" do
      election = %Koblenzomat.Election{id: Ecto.UUID.generate(), name: "Q1"}

      changeset =
        Thesis.changeset(%Thesis{}, %{name: "T1", position: 1, election_id: election.id})

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
      election = Koblenzomat.Repo.insert!(%Koblenzomat.Election{name: "Q1"})
      %{election: election}
    end

    test "position is required", %{election: election} do
      changeset = Thesis.changeset(%Thesis{}, %{name: "T1", election_id: election.id})
      refute changeset.valid?
      assert {:position, {"can't be blank", [validation: :required]}} in changeset.errors
    end

    test "position is unique within election", %{election: election} do
      attrs = %{name: "T1", position: 1, election_id: election.id}
      changeset1 = Thesis.changeset(%Thesis{}, attrs)
      {:ok, _} = Koblenzomat.Repo.insert(changeset1)

      changeset2 =
        Thesis.changeset(%Thesis{}, %{name: "T2", position: 1, election_id: election.id})

      {:error, changeset2} = Koblenzomat.Repo.insert(changeset2)

      assert {:position,
              {"has already been taken",
               [constraint: :unique, constraint_name: "theses_election_id_position_index"]}} in changeset2.errors
    end
  end

  describe "thesis auto-increment position" do
    test "auto-increments position within election" do
      election = Koblenzomat.Repo.insert!(%Koblenzomat.Election{name: "QAuto"})
      attrs = %{name: "T1", election_id: election.id}
      {:ok, thesis1} = Koblenzomat.Voting.create_thesis(attrs)

      {:ok, thesis2} =
        Koblenzomat.Voting.create_thesis(%{
          name: "T2",
          election_id: election.id
        })

      assert thesis1.position == 1
      assert thesis2.position == 2
    end
  end
end
