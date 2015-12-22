# Firmata

This package implements the Firmata protocol in Elixir.

Firmata is a MIDI-based protocol for communicating with microcontrollers.

## Limitations

* Implementing functionality on an as-needed basis, so not all functionality is implemented
* Like most libraries, this one determines if it is "connected" once it has received version and firmware info from the microcontroller. This can be an issue if connecting by XBee rather than USB-Serial

## Advantages

* Small
* Organized
* Elixir

## Feature Completeness

Because I am new to Elixir, I don't want to write too much code up-front, so I'm implementing only what I require.

*Implemented*

* Parser Mechanism
* Connection Sequence
  * Retreiving Version
  * Retreiving Firmware
  * Retreiving Pin Capabilities
  * Retreiving Analog Pin Mapping
* Toggling Analog Reporting on a pin
* Subscribing to messages (e.g. Analog Values)
* Unsubscribing from messages

*Will Implement*

* Digital Write
* Digital Read

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add firmata to your list of dependencies in `mix.exs`:

        def deps do
          [{:firmata, "~> 0.0.1"}]
        end

  2. Ensure firmata is started before your application:

        def application do
          [applications: [:firmata]]
        end
