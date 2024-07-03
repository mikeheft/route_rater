# frozen_string_literal: true

class BaseCommand
  def self.call(**args)
    new.call(args)
  end

  def call(**args)
    raise NotImplementedError, "Must define #call method"
  end
end
