#!/usr/bin/env ruby

require 'json'
require "unicode/name"

def main(input)
  input = input.strip
  items = []
  items += iphone_version(input)
  items += codepoint_emoji(input)

  puts items.compact.to_json
end

def codepoint_emoji(input)
  if input.match(/^[\\Uu0-9A-Fa-f ]+$/).nil?
    return []
  end
  matches = input.scan(/(?:\\[uU])?[0-9A-Fa-f]{4,9}/)
  if matches.any?
    string = matches.map { |m| m.gsub(/\\[uU]0*/, '').hex }.pack("U")
    decomposed =
      matches
        .map do |m|
          [m.gsub(/\\[uU]0*/, '').hex].pack("U")
        end
        .map do |u|
          {
            type: "text",
            label: Unicode::Name.of(u),
            value: u,
          }
        end
    return [{
      type: "text",
      label: string,
      value: string,
    }] + decomposed
  end
  return []
end

def iphone_version(input)
  lookup = {
    "1,1" => "",
    "1,2" => "3G",
    "2,1" => "3GS",
    "3,1" => "4",
    "3,2" => "4",
    "3,3" => "4",
    "4,1" => "4S",
    "5,1" => "5",
    "5,2" => "5",
    "5,3" => "5C",
    "5,4" => "5C",
    "6,1" => "5S",
    "6,2" => "5S",
    "7,2" => "6",
    "7,1" => "6+",
    "8,1" => "6S",
    "8,2" => "6S+",
    "8,4" => "SE",
    "9,1" => "7",
    "9,3" => "7",
    "9,2" => "7+",
    "9,4" => "7+",
    "10,1" => "8",
    "10,4" => "8",
    "10,2" => "8+",
    "10,5" => "8+",
    "10,3" => "X",
    "10,6" => "X",
    "11,2" => "XS",
    "11,4" => "XS Max",
    "11,6" => "XS Max",
    "11,8" => "XR",
    "12,1" => "11",
    "12,3" => "11 Pro",
    "12,5" => "11 Pro Max"
  }
  m = input.match(/iPhone(?<code>\d+,\d+)/)
  if m
    code = m[:code]
    if lookup.key?(code)
      name = lookup[code]
      return [{
        type: 'text',
        label: "iPhone #{name}",
        value: "iPhone #{name}"
      }]
    end
  end
  return []
end

if __FILE__ == $0
  main(ARGV[0])
end
