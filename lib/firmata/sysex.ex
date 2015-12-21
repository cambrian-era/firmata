defmodule Firmata.Protocol.Sysex do
  use Firmata.Protocol.Mixin

  def parse(state, <<@firmware_query>>, sysex) do
    Keyword.put(state, :firmware_name, firmware_query(sysex))
  end

  def parse(state, <<@capability_response>>, sysex) do
    Keyword.put(state, :pins, capability_response(sysex)[:pins])
  end

  def parse(state, <<unknown_command>>, _sysex) do
    IO.puts "Bad byte"
    state
  end

  def firmware_query(sysex) do
    Enum.slice(sysex, 4, Enum.count(sysex) - 5)
    |> Enum.reject(fn(<<b>>)-> b === 0 end)
    |> Enum.join()
  end

  def capability_response(<<byte>>, capstate) do
    cond do
      byte === 127 ->
      modes_array = Enum.reduce(@modes, [], fn(mode, modes) ->
        case (capstate[:supported_modes] &&& (1 <<< mode)) do
          0 -> modes
          _ -> [ mode | modes]
        end
      end)
      pin = [
        supported_modes: modes_array,
        mode: @unknown
      ]
      Keyword.put(capstate, :pins, [ pin | capstate[:pins] ])
      |> Keyword.put(:supported_modes, 0)
      |> Keyword.put(:n, 0)
      capstate[:n] === 0 ->
        supported_modes = capstate[:supported_modes] ||| (1 <<< byte);
        Keyword.put(capstate, :supported_modes, supported_modes)
        |> Keyword.put(:n, capstate[:n] ^^^ 1)
      true ->
        Keyword.put(capstate, :n, capstate[:n] ^^^ 1)
    end
  end

  def capability_response(sysex) do
    capstate = [supported_modes: 0, n: 0, pins: []]
    len = Enum.count(sysex)
    sysex = Enum.slice(sysex, 2, len - 3)
    Enum.reduce(sysex, capstate, &capability_response/2)
  end
end
