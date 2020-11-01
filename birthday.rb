#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"

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

birthday, name = ARGV
@user = User.new(birthday, name)
File.open('/Users/miyagawamaki/bin/DB/birthday.json', 'a', 0o755) do |file|
  file.puts @user.to_json
end
