require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  KEYS = %i[
    terraform
    resource
    variable
    output
    data
  ].freeze

  def method_missing(method_name, *args, &)
    if @in_locals
      puts %(processing local variable #{method_name})
      puts %(processing local variable value #{args[0]})
      if args[0].nil?
        raise ArgumentError,
              %(not assigning anything to this local #{method_name})
      end

      @in_locals = false
      @translation[:template][:locals].merge!(
        { method_name.to_sym => args[0] }
      )
    elsif method_name.to_s.eql?(%(locals))
      puts %(caught local execution start)

      @translation = {} if @translation.nil?
      puts @translation
      @translation[:template] = {} if @translation[:template].nil?
      puts @translation
      @translation[:template][:locals] = {} if @translation[:template][:locals].nil?
      puts @translation
      @in_locals = true
      puts @translation
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
