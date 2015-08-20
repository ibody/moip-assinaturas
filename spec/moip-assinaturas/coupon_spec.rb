require 'spec_helper'

describe Moip::Assinaturas::Coupon do 

  before do
    @coupon = {
      code: "coupon-0001",
      name: "Coupon name",
      description: "My new coupon",
      discount: {
          value: 10000,
          type: "percent"
      },
      status: "active",
      duration: {
          type: "repeating",
          occurrences: 12
      },
      max_redemptions: 1000,
      expiration_date: {
          year: 2020,
          month: 8,
          day: 1
      }
    }

    FakeWeb.register_uri(
        :post,
        "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/coupons",
        body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_coupon.json'),
        status: [201, 'OK']
      )
  end

  it "should create a new coupon" do
    request = Moip::Assinaturas::Coupon.create(@coupon)
    request[:success].should be_truthy
    request[:coupon][:code] == "coupon-0001"
  end
 
end