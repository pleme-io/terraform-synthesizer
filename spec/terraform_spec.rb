require %(terraform-synthesizer)

describe TerraformSynthesizer do
  context %(main) do
    let(:synth) do
      described_class.new
    end

    it %(should contain resource thing) do
      synth.synthesize do
        resource :aws_vpc, :thing do
          cidr_block %(10.0.0.0/16)
          stuff do
            other_stuff %(whoa)
          end
        end
        resource :aws_vpc, :thang do
          cidr_block %(10.0.0.0/16)
        end
      end
      expect(synth.synthesis[:resource][:aws_vpc][:thing]).to be_kind_of(Hash)
    end

    it %(should compile small declaration and be hash) do
      synth.synthesize do
        resource :aws_vpc, :thing do
          cidr_block %(10.0.0.0/16)
        end
        resource :aws_vpc, :thang do
          cidr_block %(10.0.0.0/16)
        end
      end
      expect(synth.synthesis).to be_kind_of(Hash)
    end

    it %(should contain locals) do
      synth.synthesize do
        resource :aws_vpc, :thing do
          cidr_block %(10.0.0.0/16)
        end
        locals do
          special_var %(special_value)
        end
        resource :aws_vpc, :thang do
          cidr_block %(10.0.0.0/16)
        end
      end
      expect(synth.synthesis[:locals][:special_var]).to be_kind_of(String)
    end

    it %(should contain resource thang) do
      synth.synthesize do
        resource :aws_vpc, :thing do
          cidr_block %(10.0.0.0/16)
        end
        locals do
          special_var %(special_value)
        end
        resource :aws_vpc, :thang do
          cidr_block %(10.0.0.0/16)
        end
      end
      expect(synth.synthesis[:resource][:aws_vpc][:thang]).to be_kind_of(Hash)
    end
  end
end
