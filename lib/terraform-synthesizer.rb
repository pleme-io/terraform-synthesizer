require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  def method_missing(method_name, *args, &)
    if method_name.to_s.eql?(%(locals))
      keys = args[0]
      if keys.length.to_s.eql(%(0))
        @translation = {} if @translation.nil?
        @translation[:template] = {} if @translation[:template].nil?
        @translation[:template][:locals] = {} if @translation[:template][:locals].nil?
        @translation[:template][:locals].merge!(instance_eval(&)) if block_given?
      else
        raise ArgumentError, %(key length for locals was more than 0, this is bad)
      end
    else
      return {}
    end
    abstract_method_missing(
      method_name,
      %i[
        terraform
        resource
        variable
        output
        data
      ],
      *args,
      &
    )
  end
end
