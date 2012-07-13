module Fabes
  class Alternative
    #TODO: move some of these to attr_reader
    attr_accessor :weight, :payload, :participants, :hits, :id

    def initialize(id, payload)
      @id = id
      @weight = 1
      @participants = 0
      @hits = 0
      @payload = payload
    end

    def increment_participants!
      @participants += 1
    end

    def increment_hits!
      @hits += 1
    end
  end
end
