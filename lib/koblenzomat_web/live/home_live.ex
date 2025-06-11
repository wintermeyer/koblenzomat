defmodule KoblenzomatWeb.HomeLive do
  use KoblenzomatWeb, :live_view

  alias Koblenzomat.Voting

  @impl true
  def mount(_params, _session, socket) do
    theses = load_and_shuffle_theses()
    socket = assign(socket, theses: theses, current: 0)
    {:ok, socket}
  end

  @impl true
  def handle_event("next", _params, socket) do
    next = socket.assigns.current + 1
    {:noreply, assign(socket, current: next)}
  end

  @impl true
  def handle_event("choose", _params, socket) do
    next = socket.assigns.current + 1
    {:noreply, assign(socket, current: next)}
  end

  defp load_and_shuffle_theses do
    # Get the first election and its theses, shuffle them
    case Voting.list_elections_with_theses() do
      [%{theses: theses} | _] -> Enum.shuffle(theses)
      _ -> []
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <main
      class="min-h-screen flex flex-col items-center justify-center relative overflow-hidden"
      aria-label="Koblenz-O-Mat"
    >
      <div
        class="absolute inset-0 z-[-10] bg-cover bg-center"
        style="background-image: url('/images/koblenz-bg.png');"
        aria-hidden="true"
      >
      </div>
      <div
        class="absolute inset-0 z-0 pointer-events-none"
        style="backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px);"
      >
      </div>
      <div class="absolute inset-0 bg-black/30 z-10" aria-hidden="true"></div>
      <header class="w-full max-w-4xl mx-auto text-center pt-8 md:pt-16 pb-8 z-10 relative">
        <h1 class="text-5xl md:text-7xl font-bold tracking-tight text-white drop-shadow-lg">
          Koblenz-O-Mat
        </h1>
        <h2 class="text-2xl md:text-3xl font-semibold mt-2 text-white/80 drop-shadow">
          {gettext("Oberbürgermeisterwahl Koblenz 2025")}
        </h2>
      </header>
      <section
        class="bg-white/90 rounded-xl shadow-xl px-4 sm:px-8 py-10 max-w-sm sm:max-w-md md:max-w-2xl w-full mx-2 sm:mx-auto flex flex-col items-center relative z-10"
        aria-labelledby="frage-titel"
      >
        <div
          class="absolute -top-8 left-1/2 -translate-x-1/2 w-0 h-0 border-l-8 border-r-8 border-b-[32px] border-l-transparent border-r-transparent border-b-white/90"
          aria-hidden="true"
        >
        </div>
        <div class="w-full text-left mb-4">
          <span id="frage-titel" class="font-semibold text-base text-slate-800">
            {@current + 1}/{length(@theses)} {gettext("These")}
          </span>
        </div>
        <div class="w-full text-left mb-8">
          <span class="block text-2xl md:text-3xl font-medium text-slate-900 leading-snug">
            {(Enum.at(@theses, @current) && Enum.at(@theses, @current).name) ||
              gettext("No more theses.")}
          </span>
          <div class="mt-2 flex flex-wrap gap-2">
            <%= for hashtag <- (Enum.at(@theses, @current) && Enum.at(@theses, @current).hashtags) || [] do %>
              <span class="inline-block bg-cyan-100 text-cyan-800 rounded px-2 py-1 text-xs font-semibold">
                #{hashtag.name}
              </span>
            <% end %>
          </div>
        </div>
        <div
          class="flex flex-col sm:flex-row gap-4 w-full justify-center mb-4"
          role="group"
          aria-labelledby="frage-titel"
        >
          <button
            phx-click="choose"
            phx-value-choice="disagree"
            class="flex-1 bg-cyan-400 hover:bg-cyan-500 text-slate-900 font-semibold py-3 rounded-lg transition focus:outline focus:outline-2 focus:outline-cyan-700"
            aria-label="Stimme nicht zu"
          >
            {gettext("stimme nicht zu")} 👎
          </button>
          <button
            phx-click="choose"
            phx-value-choice="neutral"
            class="flex-1 bg-sky-200 hover:bg-sky-300 text-slate-900 font-semibold py-3 rounded-lg transition focus:outline focus:outline-2 focus:outline-cyan-700"
            aria-label="Neutral"
          >
            {gettext("neutral")}
          </button>
          <button
            phx-click="choose"
            phx-value-choice="agree"
            class="flex-1 bg-cyan-400 hover:bg-cyan-500 text-slate-900 font-semibold py-3 rounded-lg transition focus:outline focus:outline-2 focus:outline-cyan-700"
            aria-label="Stimme zu"
          >
            👍 {gettext("stimme zu")}
          </button>
        </div>
      </section>
      <nav
        aria-label="Frage-Fortschritt"
        class="absolute bottom-10 left-1/2 -translate-x-1/2 flex gap-2 z-10"
      >
        <ol class="flex gap-2" role="list" aria-label="Frage-Fortschritt">
          <%= for i <- 0..(length(@theses)-1) do %>
            <li class={"w-3 h-3 rounded-full inline-block " <> if i == @current, do: "bg-white", else: "bg-white/30"}>
              <span class="sr-only">{gettext("Frage")} {i + 1}</span>
            </li>
          <% end %>
        </ol>
      </nav>
      <div class="absolute bottom-2 left-1/2 -translate-x-1/2 w-full max-w-2xl px-4 text-center z-10 pointer-events-none">
        <span class="text-xs text-white/70 select-none" style="font-size: 0.7rem;">
          {gettext(
            "Alle Antworten werden anonymisiert gespeichert und können von jedem in einer Gesamtstatistik eingesehen werden."
          )}
        </span>
      </div>
    </main>
    """
  end
end
