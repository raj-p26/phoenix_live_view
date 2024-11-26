defmodule Pento.LiveTest do
  use Pento.DataCase

  alias Pento.Live

  describe "results" do
    alias Pento.Live.Page

    import Pento.LiveFixtures

    @invalid_attrs %{query: nil}

    test "list_results/0 returns all results" do
      page = page_fixture()
      assert Live.list_results() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Live.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{query: "some query"}

      assert {:ok, %Page{} = page} = Live.create_page(valid_attrs)
      assert page.query == "some query"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Live.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      update_attrs = %{query: "some updated query"}

      assert {:ok, %Page{} = page} = Live.update_page(page, update_attrs)
      assert page.query == "some updated query"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Live.update_page(page, @invalid_attrs)
      assert page == Live.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Live.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Live.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Live.change_page(page)
    end
  end
end
