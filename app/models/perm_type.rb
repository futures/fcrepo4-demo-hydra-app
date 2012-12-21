class PermType < ActiveRecord::Base
  attr_accessible :code
  MODERATE = 'MODERATE'
  def self.moderate
    @mod ||= where(code: MODERATE).first
    @mod ||= create!(code: MODERATE)
    @mod
  end
end
