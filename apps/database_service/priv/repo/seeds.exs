# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DatabaseService.Repo.insert!(%DatabaseService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DatabaseService.Player.{Account, Accounts, Characters}

#
# Accounts
#

%Account{id: admin_id} =
  Accounts.create!(%{
    username: "admin",
    password: :crypto.hash(:sha512, "admin") |> Base.encode16(),
    authority: [:game_master, :administrator],
    language: :fr
  })

Accounts.create!(%{
  username: "user",
  password: :crypto.hash(:sha512, "user") |> Base.encode16()
})

#
# Characters
#

Characters.create!(%{
  account_id: admin_id,
  slot: 1,
  name: "DarkyZ",
  gender: 1,
  hair_style: 0,
  hair_color: 1,
  class: 4,
  faction: 2,
  map_id: 1,
  map_x: 40,
  map_y: 60,
  gold: 1_000_000_000,
  biography: "Hi guys! I'm DarkyZ",
  level: 92,
  job_level: 80,
  hero_level: 25,
  level_xp: 3_000,
  job_level_xp: 4_500,
  hero_level_xp: 1_000,
  reputation: 5_000_000,
  dignity: 100,
  sp_points: 10_000,
  sp_additional_points: 500_000,
  compliment: 2_000
})
