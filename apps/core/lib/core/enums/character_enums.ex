defmodule Core.CharacterEnums do
  @moduledoc """
  TODO: Documentation for Core.CharacterEnums
  """

  import SimpleEnum, only: [defenum: 2]

  defenum :state, [:unknown, :active, :inactive]
  defenum :channel_color, white: 0, green: 8, orange: 12, red: 32
  defenum :class_type, [:adventurer, :swordman, :archer, :magician, :wrestler]
  defenum :gender_type, [:male, :female]
  defenum :faction_type, [:neutral, :angel, :demon]
  defenum :hair_style_type, [:hair_style_a, :hair_style_b, :hair_style_c, :hair_style_d, :no_hair]
  defenum :miniland_state, [:open, :private, :lock]
  defenum :reputation_icon_type, [:beginner]

  # player: white name
  # game_master: purple name
  # invisible: seems only used in "eq" packet
  defenum :name_appearance, player: 0, game_master: 2, invisible: 6

  # Basic Dignity ( Dignity are not changed )
  # Suspected RANK  (Dignity: -100 ~ -200)
  # Bluffed name only RANK (Dignity: -201 ~ -400)
  # Not qualified for RANK (Dignity: -401 ~ -600)
  # Useless RANK (Dignity: -601 ~ -800)
  # Stupid minded RANK (Dignity: -801 ~ -1.000)
  defenum :dignity, [
    :invalid,
    :basic,
    :suspected,
    :bluffed_name_only,
    :not_qualified_for,
    :useless,
    :stupid_minded
  ]

  defenum :option,
    exchange_blocked: 1,
    friend_request_blocked: 2,
    family_request_blocked: 3,
    whisper_blocked: 4,
    group_request_blocked: 5,
    group_sharing: 8,
    mouse_aim_lock: 9,
    hero_chat_blocked: 10,
    emoticons_blocked: 12,
    quick_get_up: 11,
    hp_blocked: 13,
    buff_blocked: 14,
    miniland_invite_blocked: 15

  # stupid_minded: Stupid minded RANK (Dignity: -801 ~ -1.000)
  # useless: Useless RANK (Dignity: -601 ~ -800)
  # not_qualified_for: Not qualified for RANK (Dignity: -401 ~ -600)
  # bluffed_name_only: Bluffed name only RANK (Dignity: -201 ~ -400)
  # suspected: Suspected RANK  (Dignity: -100 ~ -200)
  # basic: Basic Dignity ( Dignity are not changed )
  # beginner: (0 ~ 250 Reputation)
  # unknown: Unknown ?
  # unknown2: Unknown ?
  # trainee_g: (Reputation: 251 ~ 500)
  # trainee_b: (Reputation:501 ~ 750)
  # trainee_r: (Reputation: 750 ~ 1.000)
  # the_experienced_g: (Reputation: 1.001 ~ 2.250)
  # the_experienced_b: (Reputation: 2.251 ~ 3.500)
  # the_experienced_r: (Reputation: 3.501 ~ 5.000)
  # battle_soldier_g: (Reputation: 5 001 ~ 9.500)
  # battle_soldier_b: (Reputation: 9.501 ~ 19.000)
  # battle_soldier_r: (Reputation: 19.001 ~ 25.000)
  # expert_g: (Reputation: 25.001 ~ 40.000)
  # expert_b: (Reputation: 40.001 ~ 60.000)
  # expert_r: (Reputation: 60.001 ~ 85.000)
  # leader_g: (Reputation: 85.001 ~ 115.000)
  # leader_b: (Reputation: 115.001 ~ 150.000)
  # leader_r: (Reputation: 150.001 ~ 190.000)
  # master_g: (Reputation: 190.001 ~ 235.000)
  # master_b: (Reputation: 235.001 ~ 185.000)
  # master_r: (Reputation: 285.001 ~ 350.000)
  # nos_g: (Reputation: 350.001 ~ 500.000)
  # nos_b: (Reputation: 500.001 ~ 1.500.000)
  # nos_r: (Reputation: 1.500.001 ~ 2.500.000)
  # elite_g: (Reputation: 2.500.001 ~ 3.750.000)
  # elite_b: (Reputation: 3.750.001 ~ 5.000.000)
  # elite_r: (Reputation: 5.000.001 and more )
  # legend_g: (43 th to 14 th place at the reputation ranking : 5.000.000 and more)
  # legend_b: (14 th to 4 th place at the reputation ranking : 5.000.000 and more)
  # ancien_heros: (3 rd place at the reputation ranking : 5.000.000 and more)
  # mysterious_heros: (2 nd place in the reputation ranking : 5.000.000 and more)
  # legendary_heros: (1 st place in the reputation ranking : 5.000.000 and more)
  defenum :reputation,
    stupid_minded: -6,
    useless: -5,
    not_qualified_for: -4,
    bluffed_name_only: -3,
    suspected: -2,
    basic: -1,
    beginner: 1,
    unknown: 2,
    unknown2: 3,
    trainee_g: 4,
    trainee_b: 5,
    trainee_r: 6,
    the_experienced_g: 7,
    the_experienced_b: 8,
    the_experienced_r: 9,
    battle_soldier_g: 10,
    battle_soldier_b: 11,
    battle_soldier_r: 12,
    expert_g: 13,
    expert_b: 14,
    expert_r: 15,
    leader_g: 16,
    leader_b: 17,
    leader_r: 18,
    master_g: 19,
    master_b: 20,
    master_r: 21,
    nos_g: 22,
    nos_b: 23,
    nos_r: 24,
    elite_g: 25,
    elite_b: 26,
    elite_r: 27,
    legend_g: 28,
    legend_b: 29,
    ancien_heros: 30,
    mysterious_heros: 31,
    legendary_heros: 32

  defenum :hair_color_type,
    dark_purple: 0,
    yellow: 1,
    blue: 2,
    purple: 3,
    orange: 4,
    brown: 5,
    green: 6,
    dark_grey: 7,
    light_blue: 8,
    pink_red: 9,
    light_yellow: 10,
    light_pink: 11,
    light_green: 12,
    light_grey: 13,
    sky_blue: 14,
    black: 15,
    dark_orange: 16,
    dark_orange_variant2: 17,
    dark_orange_variant3: 18,
    dark_orange_variant4: 19,
    dark_orange_variant5: 20,
    dark_orange_variant6: 21,
    light_orange: 22,
    light_light_orange: 23,
    light_light_light_orange: 24,
    light_light_light_light_orange: 25,
    super_light_orange: 26,
    dark_yellow: 27,
    light_light_yellow: 28,
    kaki_yellow: 29,
    super_light_yellow: 30,
    super_light_yellow2: 31,
    super_light_yellow3: 32,
    little_dark_yellow: 33,
    yellow_variant: 34,
    yellow_variant1: 35,
    yellow_variant2: 36,
    yellow_variant3: 37,
    yellow_variant4: 38,
    yellow_variant5: 39,
    yellow_variant6: 40,
    yellow_variant7: 41,
    yellow_variant8: 42,
    yellow_variant9: 43,
    green_variant: 44,
    green_variant1: 45,
    dark_green_variant: 46,
    green_more_dark_variant: 47,
    green_variant2: 48,
    green_variant3: 49,
    green_variant4: 50,
    green_variant5: 51,
    green_variant6: 52,
    green_variant7: 53,
    green_variant8: 54,
    green_variant9: 55,
    green_variant10: 56,
    green_variant11: 57,
    green_variant12: 58,
    green_variant13: 59,
    green_variant14: 60,
    green_variant15: 61,
    green_variant16: 62,
    green_variant17: 63,
    green_variant18: 64,
    green_variant19: 65,
    green_variant20: 66,
    light_blue_variant1: 67,
    light_blue_variant2: 68,
    light_blue_variant3: 69,
    light_blue_variant4: 70,
    light_blue_variant5: 71,
    light_blue_variant6: 72,
    light_blue_variant7: 73,
    light_blue_variant8: 74,
    light_blue_variant9: 75,
    light_blue_variant10: 76,
    light_blue_variant11: 77,
    light_blue_variant12: 78,
    light_blue_variant13: 79,
    dark_black: 80,
    light_blue_variant14: 81,
    light_blue_variant15: 82,
    light_blue_variant16: 83,
    light_blue_variant17: 84,
    blue_variant: 85,
    blue_variant_dark: 86,
    blue_variant_dark_dark: 87,
    blue_variant_dark_dark2: 88,
    flash_blue: 89,
    flash_blue_dark: 90,
    flash_blue_dark2: 91,
    flash_blue_dark3: 92,
    flash_blue_dark4: 93,
    flash_blue_dark5: 94,
    flash_blue_dark6: 95,
    flash_blue_dark7: 96,
    flash_blue_dark8: 97,
    flash_blue_dark9: 98,
    white: 99,
    flash_blue_dark10: 100,
    flash_blue1: 101,
    flash_blue2: 102,
    flash_blue3: 103,
    flash_blue4: 104,
    flash_blue5: 105,
    flash_purple: 106,
    flash_light_purple: 107,
    flash_light_purple2: 108,
    flash_light_purple3: 109,
    flash_light_purple4: 110,
    flash_light_purple5: 111,
    light_purple: 112,
    purple_variant1: 113,
    purple_variant2: 114,
    purple_variant3: 115,
    purple_variant4: 116,
    purple_variant5: 117,
    purple_variant6: 118,
    purple_variant7: 119,
    purple_variant8: 120,
    purple_variant9: 121,
    purple_variant10: 122,
    purple_variant11: 123,
    purple_variant12: 124,
    purple_variant13: 125,
    purple_variant14: 126,
    purple_variant15: 127
end
