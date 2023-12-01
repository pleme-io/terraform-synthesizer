require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  KEYS = %i[
    terraform
    resource
    variable
    output
    data
  ].freeze

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
    if @in_locals
      if args[0].nil?
        raise ArgumentError,
              %(not assigning anything to this local #{method_name})
      end

      @in_locals                                            = false
      @translation[:template][:locals][method_name.to_sym]  = args[0]

    elsif method_name.to_s.eql?(%(locals))

      @translation                      = {} if @translation.nil?
      @translation[:template]           = {} if @translation[:template].nil?
      @translation[:template][:locals]  = {} if @translation[:template][:locals].nil?
      @in_locals                        = true

      yield
    else
      abstract_method_missing(
        method_name.to_sym,
        KEYS,
        *args,
        &
      )
    end
  end
end
