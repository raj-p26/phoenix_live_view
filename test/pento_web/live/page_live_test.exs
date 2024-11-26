defmodule PentoWeb.PageLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.LiveFixtures

  @create_attrs %{query: "some query"}
  @update_attrs %{query: "some updated query"}
  @invalid_attrs %{query: nil}

  defp create_page(_) do
    page = page_fixture()
    %{page: page}
  end

  describe "Index" do
    setup [:create_page]

    test "lists all results", %{conn: conn, page: page} do
      {:ok, _index_live, html} = live(conn, ~p"/results")

      assert html =~ "Listing Results"
      assert html =~ page.query
    end

    test "saves new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("a", "New Page") |> render_click() =~
               "New Page"

      assert_patch(index_live, ~p"/results/new")

      assert index_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#page-form", page: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/results")

      html = render(index_live)
      assert html =~ "Page created successfully"
      assert html =~ "some query"
    end

    test "updates page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("#results-#{page.id} a", "Edit") |> render_click() =~
               "Edit Page"

      assert_patch(index_live, ~p"/results/#{page}/edit")

      assert index_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#page-form", page: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/results")

      html = render(index_live)
      assert html =~ "Page updated successfully"
      assert html =~ "some updated query"
    end

    test "deletes page in listing", %{conn: conn, page: page} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("#results-#{page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#results-#{page.id}")
    end
  end

  describe "Show" do
    setup [:create_page]

    test "displays page", %{conn: conn, page: page} do
      {:ok, _show_live, html} = live(conn, ~p"/results/#{page}")

      assert html =~ "Show Page"
      assert html =~ page.query
    end

    test "updates page within modal", %{conn: conn, page: page} do
      {:ok, show_live, _html} = live(conn, ~p"/results/#{page}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Page"

      assert_patch(show_live, ~p"/results/#{page}/show/edit")

      assert show_live
             |> form("#page-form", page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#page-form", page: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/results/#{page}")

      html = render(show_live)
      assert html =~ "Page updated successfully"
      assert html =~ "some updated query"
    end
  end
end
