require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  def method_missing(method_name, ...)
    if method_name.to_s.eql?(%(locals))
      @translation = {} if @translation.nil?
      @translation[:template] = {} if @translation[:template].nil?
      @translation[:template][:locals] = {} if @translation[:template][:locals].nil?
      @translation[:template][:locals].merge!(instance_eval(yield)) if block_given?
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
      ...
    )
  end
end
