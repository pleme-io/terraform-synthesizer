require %(abstract-synthesizer)

class TerraformSynthesizer < AbstractSynthesizer
  def method_missing(method_name, ...)
    abstract_method_missing(
      method_name,
      %i[
        terraform
        resource
        variable
        output
        locals
        data
      ],
      ...
    )
  end
end
