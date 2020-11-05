#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'optparse'

class User
  attr :birthday, :name
  def initialize(birthday, name)
    @birthday, @name = birthday, name
  end

  def self.json_create(object)
    new(object['birthday'], object['name'])
  end

  def as_json(*)
    {
      "birthday" => birthday,
      "name" => name,
    }
  end

  def to_json(*)
    as_json.to_json
  end
end

birthday_array = IO.readlines('/Users/miyagawamaki/bin/DB/birthday.json', chomp: true)

options = ARGV.getopts('s')
name, birthday = ARGV if ARGV
@user ||= User.new(birthday, name)

birthday_data = []
birthday_array.each do |line|
  birthday_data << JSON.parse(line)
end

if options['s']
  birthday_data.each do |birthday|
    if birthday['name'] == name
      puts birthday['birthday']
    elsif birthday['birthday'] == name
      puts birthday['name']
    end
  end
else
  File.open('/Users/miyagawamaki/bin/DB/birthday.json', 'a', 0o755) do |file|
    file.puts @user.to_json unless @user.name.nil?
  end
end
