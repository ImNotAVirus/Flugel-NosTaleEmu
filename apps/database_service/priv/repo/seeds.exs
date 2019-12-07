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

alias DatabaseService.Repo
alias DatabaseService.Player.Account

#
# Accounts
#

{:ok, admin_authority} = Account.AuthorityType.cast([:game_master, :administrator])

Repo.insert!(%Account{
  username: "admin",
  password: :crypto.hash(:sha512, "admin") |> Base.encode16(),
  authority: admin_authority,
  language: :fr
})

Repo.insert!(%Account{
  username: "user",
  password: :crypto.hash(:sha512, "user") |> Base.encode16()
})
