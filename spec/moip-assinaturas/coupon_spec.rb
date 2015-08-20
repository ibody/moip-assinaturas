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

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/coupons",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_coupons.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/coupons/coupon-0001",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_coupon.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/coupons/coupon-0001/active",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'active_coupon.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/coupons/coupon-0001/inactive",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'inactive_coupon.json'),
      status: [200, 'OK']
    )
  end

  it "should create a new coupon" do
    request = Moip::Assinaturas::Coupon.create(@coupon)
    request[:success].should be_truthy
    request[:coupon][:code] == "coupon-0001"
  end

  it "should list all coupons" do
    request = Moip::Assinaturas::Coupon.list
    request[:success].should be_truthy
    request[:coupons].size.should == 1
  end

  it "details a coupon" do
    request = Moip::Assinaturas::Coupon.details('coupon-0001')
    request[:success].should be_truthy
    request[:coupon][:code] == "coupon-0001"
  end

  it "should active a coupon" do
    request = Moip::Assinaturas::Coupon.active('coupon-0001')
    request[:success].should be_truthy
    request[:coupon][:code] == "coupon-0001"
    request[:coupon][:status] == "active"
  end

  it "should inactive a coupon" do
    request = Moip::Assinaturas::Coupon.inactive('coupon-0001')
    request[:success].should be_truthy
    request[:coupon][:code] == "coupon-0001"
    request[:coupon][:status] == "inactive"
  end

end