require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  def method_missing(method_name, *args, &block)
    abstract_method_missing(
      method_name,
      %i[
        terraform
        resource
        variable
        data
      ],
      *args,
      &block
    )
  end
end
