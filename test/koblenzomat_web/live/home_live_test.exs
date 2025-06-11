defmodule KoblenzomatWeb.HomeLiveTest do
  use KoblenzomatWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders and shuffles through theses", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "main[aria-label=\"Koblenz-O-Mat\"]")
    assert has_element?(view, "button", "stimme zu")
    assert has_element?(view, "button", "neutral")
    assert has_element?(view, "button", "stimme nicht zu")
    assert has_element?(view, "button", "These überspringen")
  end

  test "clicking a choice advances to the next thesis", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    # Get the current thesis text
    current_thesis = render(view)

    # Click 'stimme zu'
    assert view |> element("button[phx-value-choice=agree]") |> render_click()
    next_thesis = render(view)
    assert current_thesis != next_thesis

    # Click 'neutral'
    assert view |> element("button[phx-value-choice=neutral]") |> render_click()
    next_thesis2 = render(view)
    assert next_thesis != next_thesis2

    # Click 'stimme nicht zu'
    assert view |> element("button[phx-value-choice=disagree]") |> render_click()
    next_thesis3 = render(view)
    assert next_thesis2 != next_thesis3
  end
end
