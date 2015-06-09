require "spec_helper"

describe  Moip::Assinaturas::Client do

  context "OAuth headers" do

    it { expect{described_class.details_payment("PAY-123456789012", moip_auth: { oauth: {accessToken: "sefghjrs"}, sandbox: true} )}.to raise_error  Moip::Assinaturas::MissingTokenError }

    it { expect{described_class.details_payment("PAY-123456789012", moip_auth: { oauth: {accessToken: nil}, sandbox: true} )}.to raise_error  Moip::Assinaturas::MissingTokenError }

  end

end