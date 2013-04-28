require 'spec_helper'

describe Moip::Assinaturas do
  
  it "should can use the config method to configure the core class" do
    Moip::Assinaturas.config do |config|
      config.token = "YSV8NRJLQVS9JNFURG"
      config.key   = "ZP33V52G90EBISZMONKBSA5TT18KC33"
    end

    Moip::Assinaturas.token.should  == "YSV8NRJLQVS9JNFURG"
    Moip::Assinaturas.key.should    == "ZP33V52G90EBISZMONKBSA5TT18KC33"
  end

end