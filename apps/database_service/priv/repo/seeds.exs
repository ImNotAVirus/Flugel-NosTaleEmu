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

alias DatabaseService.Player.Accounts

#
# Accounts
#

Accounts.create_account!(%{
  username: "admin",
  password: :crypto.hash(:sha512, "admin") |> Base.encode16(),
  authority: [:game_master, :administrator],
  language: :fr
})

Accounts.create_account!(%{
  username: "user",
  password: :crypto.hash(:sha512, "user") |> Base.encode16()
})