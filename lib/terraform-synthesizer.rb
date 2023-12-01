require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  RESOURCE_KEYS = %i[
    terraform
    resource
    variable
    output
    data
  ].freeze

  # if there are additional block keys
  # add them here and they should be processed
  # accordingly
  BLOCK_KEYS = %i[locals].freeze

  ##############################################################################
  # notes:
  #
  # locals are processed as a direct block like
  # locals do
  #   key value
  # end
  # while resources are processed as resource like blocks
  # resource :aws_vpc, :virtual_name do
  #   key value
  # end
  ##############################################################################
  def method_missing(method_name, *args, &)
    BLOCK_KEYS.each do |block_key|
      if @in_block_key
        raise ArgumentError, %(not assigning anything to this #{block_key}) if args[0].nil? || args[0].empty?

        @in_block_key = false
        @translation[:template][block_key.to_sym][method_name.to_sym] = args[0]

      elsif method_name.to_s.eql?(block_key.to_s)

        @translation = {} if @translation.nil?
        @translation[:template] = {} if @translation[:template].nil?
        if @translation[:template][block_key.to_sym].nil?
          @translation[:template][block_key.to_sym] =
            {}
        end
        @in_block_key = true

        yield
      else
        abstract_method_missing(
          method_name.to_sym,
          RESOURCE_KEYS,
          *args,
          &
        )
      end
    end
  end
end
