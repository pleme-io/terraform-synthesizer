require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  def method_missing(method_name, ...)
    if @in_locals
      if args[0].nil?
        raise ArgumentError,
              %(not assigning anything to this local #{method_name})
      end

      @translation[:template][:locals][method_name.to_sym] = args[0]
      @in_locals = false
    end
    if method_name.to_s.eql?(%(locals))
      @translation = {} if @translation.nil?
      @translation[:template] = {} if @translation[:template].nil?
      @translation[:template][:locals] = {} if @translation[:template][:locals].nil?
      @translation[:template][:locals].merge!(yield) if block_given?
      @in_locals = true
    else
      return {} if @in_locals

      abstract_method_missing(
        method_name,
        %i[
          terraform
          resource
          variable
          output
          data
        ],
        ...
      )
    end
  end
end
