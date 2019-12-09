defmodule DatabaseService.Enums do
  @moduledoc false

  import EctoEnum

  ## Account enums
  defenum LanguageKey, :language_key, [:fr, :en]

  ## Character enums
  defenum GenderType, male: 0, female: 1

  defenum FactionType,
    neutral: 0,
    angel: 1,
    demon: 2

  defenum CharacterClassType,
    adventurer: 0,
    swordman: 1,
    archer: 2,
    magician: 3,
    wrestler: 4

  defenum HairStyleType,
    hair_style_a: 0,
    hair_style_b: 1,
    hair_style_c: 2,
    hair_style_d: 3,
    no_hair: 4

  defenum HairColorType,
    dark_purple: 0,
    yellow: 1,
    blue: 2,
    purple: 3,
    orange: 4,
    brown: 5,
    green: 6,
    dark_grey: 7,
    light_blue: 8,
    pink_red: 9
end
