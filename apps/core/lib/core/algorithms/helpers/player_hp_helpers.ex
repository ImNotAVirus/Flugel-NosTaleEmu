defmodule Core.Algorithms.PlayerHpHelpers do
  @moduledoc false

  defmacro define_get_hp(:adventurer, level) do
    base_hp = 205
    base_inc = 1
    __define_fn__(:adventurer, level, base_hp, base_inc, 1.10)
  end

  defmacro define_get_hp(:magician, level) do
    base_hp = 350
    base_inc = 8
    __define_fn__(:magician, level, base_hp, base_inc)
  end

  defmacro define_get_hp(:swordman, level) do
    base_hp = 300
    base_inc = 20
    __define_fn__(:swordman, level, base_hp, base_inc, 1.10)
  end

  defmacro define_get_hp(:archer, level) do
    base_hp = 320
    base_inc = 15
    __define_fn__(:archer, level, base_hp, base_inc, 1.04)
  end

  defmacro define_get_hp(:wrestler, level) do
    base_hp = 400
    base_inc = 16
    __define_fn__(:wrestler, level, base_hp, base_inc, 1.14)
  end

  ## Helpers

  @doc false
  def __define_fn__(class, level, base_hp, base_inc, delta \\ nil) do
    quote bind_quoted: [
            class: class,
            base_hp: base_hp,
            base_inc: base_inc,
            level: level,
            delta: delta
          ] do
      d = if delta == nil, do: 1.0, else: max(delta * (min(level * 2, 100) / 100), 1.0)
      hp = round((base_hp + level * (base_inc + level) * 0.90) * d)
      def get_hp(unquote(class), unquote(level)), do: unquote(hp)
    end
  end
end
