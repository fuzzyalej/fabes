module Fabes
  class Alternative
    #TODO: move some of these to attr_reader
    attr_accessor :weight, :payload, :participants, :hits, :id

    def initialize(payload)
      @id = generate_id
      @weight = 1
      @participants = 0
      @hits = 0
      @payload = payload
    end

    #TODO: save to redis?
    def increment_participants!
      @participants += 1
    end

    def increment_hits!
      @hits += 1
    end

    def self.create_from(data)
      alternative = new(data.delete :payload)
      data.each do |k, v|
        alternative.send "#{k}=", v
      end
      alternative
    rescue
      raise 'Error creating an alternative'
    end

    private

    def generate_id
      #TODO: maybe this could be easier with a redis counter?
      rand(36**10).to_s(36)
    end
  end
end
