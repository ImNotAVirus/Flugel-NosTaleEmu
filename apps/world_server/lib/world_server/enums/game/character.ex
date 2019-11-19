defmodule WorldServer.Enums.Game.Character do
  @moduledoc """
  TODO: Documentation for WorldServer.Enums.Game.Character
  """

  @spec channel_color(atom) :: non_neg_integer
  def channel_color(:white), do: 0
  def channel_color(:green), do: 8
  def channel_color(:orange), do: 12
  def channel_color(:red), do: 32

  @spec class_type(atom) :: non_neg_integer
  def class_type(:adventurer), do: 0
  def class_type(:swordman), do: 1
  def class_type(:archer), do: 2
  def class_type(:magician), do: 3
  def class_type(:wrestler), do: 4
  def class_type(:unknown), do: 5

  @spec dignity(atom) :: non_neg_integer
  # Basic Dignity ( Dignity are not changed )
  def dignity(:basic), do: 1
  # Suspected RANK  (Dignity: -100 ~ -200)
  def dignity(:suspected), do: 2
  # Bluffed name only RANK (Dignity: -201 ~ -400)
  def dignity(:bluffed_name_only), do: 3
  # Not qualified for RANK (Dignity: -401 ~ -600)
  def dignity(:not_qualified_for), do: 4
  # Useless RANK (Dignity: -601 ~ -800)
  def dignity(:useless), do: 5
  # Stupid minded RANK (Dignity: -801 ~ -1.000)
  def dignity(:stupid_minded), do: 6

  @spec name_appearance(atom) :: non_neg_integer
  # white name
  def name_appearance(:player), do: 0
  # violet name
  def name_appearance(:game_master), do: 2
  # seems only used in "eq" packet
  def name_appearance(:invisible), do: 6

  @spec option(atom) :: non_neg_integer
  def option(:exchange_blocked), do: 1
  def option(:friend_request_blocked), do: 2
  def option(:family_request_blocked), do: 3
  def option(:whisper_blocked), do: 4
  def option(:group_request_blocked), do: 5
  def option(:group_sharing), do: 8
  def option(:mouse_aim_lock), do: 9
  def option(:hero_chat_blocked), do: 10
  def option(:emoticons_blocked), do: 12
  def option(:quick_get_up), do: 11
  def option(:hp_blocked), do: 13
  def option(:buff_blocked), do: 14
  def option(:miniland_invite_blocked), do: 15

  @spec rep(atom) :: integer
  # Stupid minded RANK (Dignity: -801 ~ -1.000)
  def rep(:stupid_minded), do: -6
  # Useless RANK (Dignity: -601 ~ -800)
  def rep(:useless), do: -5
  # Not qualified for RANK (Dignity: -401 ~ -600)
  def rep(:not_qualified_for), do: -4
  # Bluffed name only RANK (Dignity: -201 ~ -400)
  def rep(:bluffed_name_only), do: -3
  # Suspected RANK  (Dignity: -100 ~ -200)
  def rep(:suspected), do: -2
  # Basic Dignity ( Dignity are not changed )
  def rep(:basic), do: -1
  # (0 ~ 250 Reputation)
  def rep(:beginner), do: 1
  # IDK ?
  def rep(:i_dk), do: 2
  # IDK ?
  def rep(:i_dk2), do: 3
  # (Reputation: 251 ~ 500)
  def rep(:trainee_g), do: 4
  # (Reputation:501 ~ 750)
  def rep(:trainee_b), do: 5
  # (Reputation: 750 ~ 1.000)
  def rep(:trainee_r), do: 6
  # (Reputation: 1.001 ~ 2.250)
  def rep(:the_experienced_g), do: 7
  # (Reputation: 2.251 ~ 3.500)
  def rep(:the_experienced_b), do: 8
  # (Reputation: 3.501 ~ 5.000)
  def rep(:the_experienced_r), do: 9
  # (Reputation: 5 001 ~ 9.500)
  def rep(:battle_soldier_g), do: 10
  # (Reputation: 9.501 ~ 19.000)
  def rep(:battle_soldier_b), do: 11
  # (Reputation: 19.001 ~ 25.000)
  def rep(:battle_soldier_r), do: 12
  # (Reputation: 25.001 ~ 40.000)
  def rep(:expert_g), do: 13
  # (Reputation: 40.001 ~ 60.000)
  def rep(:expert_b), do: 14
  # (Reputation: 60.001 ~ 85.000)
  def rep(:expert_r), do: 15
  # (Reputation: 85.001 ~ 115.000)
  def rep(:leader_g), do: 16
  # (Reputation: 115.001 ~ 150.000)
  def rep(:leader_b), do: 17
  # (Reputation: 150.001 ~ 190.000)
  def rep(:leader_r), do: 18
  # (Reputation: 190.001 ~ 235.000)
  def rep(:master_g), do: 19
  # (Reputation: 235.001 ~ 185.000)
  def rep(:master_b), do: 20
  # (Reputation: 285.001 ~ 350.000)
  def rep(:master_r), do: 21
  # (Reputation: 350.001 ~ 500.000)
  def rep(:nos_g), do: 22
  # (Reputation: 500.001 ~ 1.500.000)
  def rep(:nos_b), do: 23
  # (Reputation: 1.500.001 ~ 2.500.000)
  def rep(:nos_r), do: 24
  # (Reputation: 2.500.001 ~ 3.750.000)
  def rep(:elite_g), do: 25
  # (Reputation: 3.750.001 ~ 5.000.000)
  def rep(:elite_b), do: 26
  # (Reputation: 5.000.001 and more )
  def rep(:elite_r), do: 27
  # (43 th to 14 th place at the reputation ranking : 5.000.000 and more)
  def rep(:legend_g), do: 28
  # (14 th to 4 th place at the reputation ranking : 5.000.000 and more)
  def rep(:legend_b), do: 29
  # (3 rd place at the reputation ranking : 5.000.000 and more)
  def rep(:ancien_heros), do: 30
  # (2 nd place in the reputation ranking : 5.000.000 and more)
  def rep(:mysterious_heros), do: 31
  # (1 st place in the reputation ranking : 5.000.000 and more)
  def rep(:legendary_heros), do: 32

  @spec state(atom) :: non_neg_integer
  def state(:unknown), do: 0
  def state(:active), do: 1
  def state(:inactive), do: 2

  @spec faction_type(atom) :: non_neg_integer
  def faction_type(:neutral), do: 0
  def faction_type(:angel), do: 1
  def faction_type(:demon), do: 2

  @spec gender_type(atom) :: non_neg_integer
  def gender_type(:male), do: 0
  def gender_type(:female), do: 1

  @spec hair_color_type(atom) :: non_neg_integer
  def hair_color_type(:dark_purple), do: 0
  def hair_color_type(:yellow), do: 1
  def hair_color_type(:blue), do: 2
  def hair_color_type(:purple), do: 3
  def hair_color_type(:orange), do: 4
  def hair_color_type(:brown), do: 5
  def hair_color_type(:green), do: 6
  def hair_color_type(:dark_grey), do: 7
  def hair_color_type(:light_blue), do: 8
  def hair_color_type(:pink_red), do: 9
  def hair_color_type(:light_yellow), do: 10
  def hair_color_type(:light_pink), do: 11
  def hair_color_type(:light_green), do: 12
  def hair_color_type(:light_grey), do: 13
  def hair_color_type(:sky_blue), do: 14
  def hair_color_type(:black), do: 15
  def hair_color_type(:dark_orange), do: 16
  def hair_color_type(:dark_orange_variant2), do: 17
  def hair_color_type(:dark_orange_variant3), do: 18
  def hair_color_type(:dark_orange_variant4), do: 19
  def hair_color_type(:dark_orange_variant5), do: 20
  def hair_color_type(:dark_orange_variant6), do: 21
  def hair_color_type(:light_orange), do: 22
  def hair_color_type(:light_light_orange), do: 23
  def hair_color_type(:light_light_light_orange), do: 24
  def hair_color_type(:light_light_light_light_orange), do: 25
  def hair_color_type(:super_light_orange), do: 26
  def hair_color_type(:dark_yellow), do: 27
  def hair_color_type(:light_light_yellow), do: 28
  def hair_color_type(:kaki_yellow), do: 29
  def hair_color_type(:super_light_yellow), do: 30
  def hair_color_type(:super_light_yellow2), do: 31
  def hair_color_type(:super_light_yellow3), do: 32
  def hair_color_type(:little_dark_yellow), do: 33
  def hair_color_type(:yellow_variant), do: 34
  def hair_color_type(:yellow_variant1), do: 35
  def hair_color_type(:yellow_variant2), do: 36
  def hair_color_type(:yellow_variant3), do: 37
  def hair_color_type(:yellow_variant4), do: 38
  def hair_color_type(:yellow_variant5), do: 39
  def hair_color_type(:yellow_variant6), do: 40
  def hair_color_type(:yellow_variant7), do: 41
  def hair_color_type(:yellow_variant8), do: 42
  def hair_color_type(:yellow_variant9), do: 43
  def hair_color_type(:green_variant), do: 44
  def hair_color_type(:green_variant1), do: 45
  def hair_color_type(:dark_green_variant), do: 46
  def hair_color_type(:green_more_dark_variant), do: 47
  def hair_color_type(:green_variant2), do: 48
  def hair_color_type(:green_variant3), do: 49
  def hair_color_type(:green_variant4), do: 50
  def hair_color_type(:green_variant5), do: 51
  def hair_color_type(:green_variant6), do: 52
  def hair_color_type(:green_variant7), do: 53
  def hair_color_type(:green_variant8), do: 54
  def hair_color_type(:green_variant9), do: 55
  def hair_color_type(:green_variant10), do: 56
  def hair_color_type(:green_variant11), do: 57
  def hair_color_type(:green_variant12), do: 58
  def hair_color_type(:green_variant13), do: 59
  def hair_color_type(:green_variant14), do: 60
  def hair_color_type(:green_variant15), do: 61
  def hair_color_type(:green_variant16), do: 62
  def hair_color_type(:green_variant17), do: 63
  def hair_color_type(:green_variant18), do: 64
  def hair_color_type(:green_variant19), do: 65
  def hair_color_type(:green_variant20), do: 66
  def hair_color_type(:light_blue_variant1), do: 67
  def hair_color_type(:light_blue_variant2), do: 68
  def hair_color_type(:light_blue_variant3), do: 69
  def hair_color_type(:light_blue_variant4), do: 70
  def hair_color_type(:light_blue_variant5), do: 71
  def hair_color_type(:light_blue_variant6), do: 72
  def hair_color_type(:light_blue_variant7), do: 73
  def hair_color_type(:light_blue_variant8), do: 74
  def hair_color_type(:light_blue_variant9), do: 75
  def hair_color_type(:light_blue_variant10), do: 76
  def hair_color_type(:light_blue_variant11), do: 77
  def hair_color_type(:light_blue_variant12), do: 78
  def hair_color_type(:light_blue_variant13), do: 79
  def hair_color_type(:dark_black), do: 80
  def hair_color_type(:light_blue_variant14), do: 81
  def hair_color_type(:light_blue_variant15), do: 82
  def hair_color_type(:light_blue_variant16), do: 83
  def hair_color_type(:light_blue_variant17), do: 84
  def hair_color_type(:blue_variant), do: 85
  def hair_color_type(:blue_variant_dark), do: 86
  def hair_color_type(:blue_variant_dark_dark), do: 87
  def hair_color_type(:blue_variant_dark_dark2), do: 88
  def hair_color_type(:flash_blue), do: 89
  def hair_color_type(:flash_blue_dark), do: 90
  def hair_color_type(:flash_blue_dark2), do: 91
  def hair_color_type(:flash_blue_dark3), do: 92
  def hair_color_type(:flash_blue_dark4), do: 93
  def hair_color_type(:flash_blue_dark5), do: 94
  def hair_color_type(:flash_blue_dark6), do: 95
  def hair_color_type(:flash_blue_dark7), do: 96
  def hair_color_type(:flash_blue_dark8), do: 97
  def hair_color_type(:flash_blue_dark9), do: 98
  def hair_color_type(:white), do: 99
  def hair_color_type(:flash_blue_dark10), do: 100
  def hair_color_type(:flash_blue1), do: 101
  def hair_color_type(:flash_blue2), do: 102
  def hair_color_type(:flash_blue3), do: 103
  def hair_color_type(:flash_blue4), do: 104
  def hair_color_type(:flash_blue5), do: 105
  def hair_color_type(:flash_purple), do: 106
  def hair_color_type(:flash_light_purple), do: 107
  def hair_color_type(:flash_light_purple2), do: 108
  def hair_color_type(:flash_light_purple3), do: 109
  def hair_color_type(:flash_light_purple4), do: 110
  def hair_color_type(:flash_light_purple5), do: 111
  def hair_color_type(:light_purple), do: 112
  def hair_color_type(:purple_variant1), do: 113
  def hair_color_type(:purple_variant2), do: 114
  def hair_color_type(:purple_variant3), do: 115
  def hair_color_type(:purple_variant4), do: 116
  def hair_color_type(:purple_variant5), do: 117
  def hair_color_type(:purple_variant6), do: 118
  def hair_color_type(:purple_variant7), do: 119
  def hair_color_type(:purple_variant8), do: 120
  def hair_color_type(:purple_variant9), do: 121
  def hair_color_type(:purple_variant10), do: 122
  def hair_color_type(:purple_variant11), do: 123
  def hair_color_type(:purple_variant12), do: 124
  def hair_color_type(:purple_variant13), do: 125
  def hair_color_type(:purple_variant14), do: 126
  def hair_color_type(:purple_variant15), do: 127

  @spec hair_style_type(atom) :: non_neg_integer
  def hair_style_type(:hair_style_a), do: 0
  def hair_style_type(:hair_style_b), do: 1
  def hair_style_type(:hair_style_c), do: 2
  def hair_style_type(:hair_style_d), do: 3
  def hair_style_type(:no_hair), do: 4

  @spec miniland_state(atom) :: non_neg_integer
  def miniland_state(:open), do: 0
  def miniland_state(:private), do: 1
  def miniland_state(:lock), do: 2

  @spec reputation_icon_type(atom) :: non_neg_integer
  def reputation_icon_type(:beginner), do: 0
end
