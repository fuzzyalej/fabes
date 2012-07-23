module Fabes
  class Alternative
    #TODO: move some of these to attr_reader
    attr_accessor :weight, :payload, :participants, :hits, :id

    def initialize(payload)
      @id = generate_id
      @weight = 0.1
      @participants = 0
      @hits = 0
      @payload = payload
    end

    def increment_participants!
      @participants = @participants.to_i + 1
      Fabes.db.increment_participants!(id)
    end

    def increment_hits!
      @hits = @hits.to_i + 1
      Fabes.db.increment_hits!(id)
    end

    def update_weight
      @weight = calculate_weight
      Fabes.db.update_weight(id, @weight)
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

    def weight
      @weight.to_f
    end

    private

    def generate_id
      #TODO: maybe this could be easier with a redis counter?
      rand(36**10).to_s(36)
    end

    def calculate_weight
      @hits.to_f / @participants.to_f
    end
  end
end
