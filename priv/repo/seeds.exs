# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Koblenzomat.Repo.insert!(%Koblenzomat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Koblenzomat.{Repo, Hashtag, HashtagsToTheses}

seed_data = [
  {"Koblenz soll neue Baugebiete ausweisen, auch wenn dafür Freiflächen genutzt werden müssen.",
   ["Stadtentwicklung", "Wohnen"]},
  {"Die Innenstadt soll stärker verdichtet bebaut werden, statt neue Siedlungsflächen am Stadtrand zu schaffen.",
   ["Stadtentwicklung", "Wohnen"]},
  {"Die Seilbahn über den Rhein soll über 2026 hinaus dauerhaft erhalten bleiben.",
   ["Tourismus", "Verkehr"]},
  {"Koblenz soll die BUGA 2029 aktiv als Motor für Stadtentwicklungs­projekte nutzen.",
   ["Stadtentwicklung", "Kultur", "Tourismus"]},
  {"Mehr ausgewiesene Fahrradstraßen und Radwege auch auf Kosten von Parkplätzen.",
   ["Mobilität", "Radverkehr"]},
  {"Flächendeckend Tempo 30 als Regelgeschwindigkeit (Ausnahmen für Hauptachsen).",
   ["Mobilität", "Verkehr", "Sicherheit"]},
  {"Höhere Parkgebühren in der Innenstadt, um Autoverkehr zu reduzieren.",
   ["Mobilität", "Auto", "Finanzen"]},
  {"Die Fußgängerzone in der Innenstadt soll erweitert werden.",
   ["Mobilität", "Stadtentwicklung"]},
  {"Der ÖPNV soll langfristig ticketfrei werden.", ["ÖPNV", "Mobilität", "Finanzen"]},
  {"Die Stadt soll die Einführung eines Stadtbahn-/Straßenbahn­systems prüfen.",
   ["ÖPNV", "Infrastruktur"]},
  {"Mehr öffentliche E-Ladesäulen im gesamten Stadtgebiet.",
   ["Energie", "Mobilität", "Klimaschutz"]},
  {"Die Stadt soll zusätzliche Sozialwohnungen bauen bzw. bauen lassen.", ["Wohnen", "Soziales"]},
  {"Bei Neubauprojekten soll ein fester Anteil bezahlbarer Wohnraum gesichert werden.",
   ["Wohnen", "Soziales"]},
  {"Die Umwandlung von Wohnungen in Ferienwohnungen soll strenger geregelt werden.",
   ["Wohnen", "Stadtentwicklung", "Tourismus"]},
  {"Kommunale Baugrundstücke bevorzugt an gemeinnützige oder genossenschaftliche Projekte vergeben.",
   ["Wohnen", "Soziales"]},
  {"Gegen dauerhaften Leerstand von Wohnungen soll konsequent vorgegangen werden.",
   ["Wohnen", "Stadtentwicklung"]},
  {"Neubau und Sanierung von Schulen und Sporthallen erhalten höchste Priorität.",
   ["Bildung", "Infrastruktur"]},
  {"Alle Koblenzer Schulen sollen vollständig digital ausgestattet sein.",
   ["Bildung", "Digitalisierung"]},
  {"Das Netz ganztägiger Schulangebote soll ausgeweitet werden.", ["Bildung", "Soziales"]},
  {"Wohnortnahe Kita-Plätze sollen deutlich ausgebaut werden.", ["Kita", "Familie", "Soziales"]},
  {"Die Stadtverwaltung soll bis 2030 sämtliche Bürgerdienste digital anbieten.",
   ["Digitalisierung", "Verwaltung"]},
  {"Kostenloses öffentliches WLAN auf zentralen Plätzen einrichten.",
   ["Digitalisierung", "Infrastruktur"]},
  {"Smart-City-Technologien wie intelligente Ampeln flächendeckend einführen.",
   ["Digitalisierung", "Infrastruktur", "Mobilität"]},
  {"Eine städtische Bürger-App für Meldungen und Informationen einführen.",
   ["Digitalisierung", "Bürgerbeteiligung"]},
  {"Erneuerbare Energien auf städtischen Flächen deutlich ausbauen.", ["Energie", "Klimaschutz"]},
  {"Für alle Neubauten soll eine Solardach­pflicht gelten.", ["Energie", "Klimaschutz"]},
  {"Koblenz soll den Klimanotstand ausrufen und Klimaschutz priorisieren.",
   ["Klimaschutz", "Umwelt"]},
  {"Einführung einer Umweltzone, die hoch­emittierende Fahrzeuge ausschließt.",
   ["Umwelt", "Mobilität"]},
  {"Städtische Veranstaltungen sollen weitgehend auf Einwegplastik verzichten.",
   ["Umwelt", "Kultur"]},
  {"Fluss- und Bachufer im Stadtgebiet sollen renaturiert werden.", ["Umwelt", "Klimaanpassung"]},
  {"Die Gewerbesteuer soll gesenkt werden, um Unternehmen anzuziehen.",
   ["Wirtschaft", "Finanzen"]},
  {"Stadtmarketing und Tourismusförderung sollen ausgebaut werden.", ["Wirtschaft", "Tourismus"]},
  {"Verkaufsoffene Sonntage sollen ermöglicht werden.", ["Wirtschaft", "Einzelhandel"]},
  {"Videoüberwachung an öffentlichen Plätzen soll ausgeweitet werden.",
   ["Sicherheit", "Überwachung"]},
  {"Nächtliche Alkoholverbote auf ausgewählten Plätzen einführen.", ["Sicherheit", "Soziales"]},
  {"Präventionsprogramme gegen Gewalt und Drogen für Jugendliche ausbauen.",
   ["Soziales", "Jugend", "Sicherheit"]},
  {"Mehr kostenlose Beratungs- und Hilfs­angebote für obdachlose Menschen.",
   ["Soziales", "Wohnen"]},
  {"Zusätzliche Jugendzentren und Freizeit­einrichtungen schaffen.", ["Soziales", "Jugend"]},
  {"Integration Zugewanderter durch städtische Programme stärker fördern.",
   ["Integration", "Soziales"]},
  {"Ein Sozialticket für den ÖPNV einführen.", ["ÖPNV", "Soziales", "Mobilität"]},
  {"Kulturelle Einrichtungen sollen höhere städtische Zuschüsse erhalten.",
   ["Kultur", "Finanzen"]},
  {"Verwaltungsprozesse sollen vereinfacht und Genehmigungen beschleunigt werden.",
   ["Verwaltung", "Digitalisierung"]},
  {"Einführung eines Bürgerhaushalts mit Entscheidungsrecht der Bevölkerung.",
   ["Bürgerbeteiligung", "Finanzen"]},
  {"Arbeitsbedingungen und Bezahlung im Rathaus verbessern, um Fachkräfte zu gewinnen.",
   ["Verwaltung", "Personal"]},
  {"Die Stadt soll keine neuen Schulden aufnehmen und einen ausgeglichenen Haushalt anstreben.",
   ["Finanzen", "Haushalt"]},
  {"Notwendige Investitionen sollen notfalls auch kreditfinanziert umgesetzt werden.",
   ["Finanzen", "Infrastruktur"]},
  {"Die Grundsteuer soll gesenkt werden.", ["Finanzen", "Wohnen"]},
  {"Kultur- und Sportförderung soll auch in Haushalts­krisen nicht gekürzt werden.",
   ["Kultur", "Sport", "Finanzen"]},
  {"Bundeswehr­standorte in Koblenz sollen aktiv unterstützt und ausgebaut werden.",
   ["Bundeswehr", "Wirtschaft", "Sicherheit"]},
  {"Bürgerentscheide zu großen Projekten sollen ermöglicht werden, wenn ein Quorum erreicht wird.",
   ["DirekteDemokratie", "Bürgerbeteiligung"]}
]

# Insert hashtags
hashtags =
  seed_data
  |> Enum.flat_map(fn {_, tags} -> tags end)
  |> Enum.uniq()
  |> Enum.map(fn tag ->
    Repo.insert!(%Hashtag{name: tag}, on_conflict: :nothing, conflict_target: :name)
    Repo.get_by!(Hashtag, name: tag)
  end)

hashtag_map = Map.new(hashtags, &{&1.name, &1.id})

# Create a questionnaire for all theses
questionnaire = Repo.insert!(%Koblenzomat.Questionnaire{name: "Seed Questionnaire"})

# Insert theses and associations
for {thesis_text, tags} <- seed_data do
  {:ok, thesis} = Koblenzomat.Questionnaires.create_thesis(%{name: thesis_text, questionnaire_id: questionnaire.id})
  for tag <- tags do
    Repo.insert!(%HashtagsToTheses{thesis_id: thesis.id, hashtag_id: hashtag_map[tag]})
  end
end
