# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Payment do

  before(:all) do

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/invoices/13/payments", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_payments.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/payments/6", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_payment.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/invoices/14/payments", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'list_payments.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/payments/7", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'details_payment.json'),
      status: [200, 'OK']
    )

  end

  it "should get all payments from a invoice" do
    request = Moip::Assinaturas::Payment.list(13)
    request[:success].should    be_truthy
    request[:payments].size.should == 1
  end

  it "should get details of a payment" do
    request = Moip::Assinaturas::Payment.details(6)
    request[:success].should        be_truthy
    request[:payment][:id].should   == 6
  end

  context "Custom Authentication" do
    it "should get all payments from a invoice" do
      request = Moip::Assinaturas::Payment.list(14, moip_auth: $custom_moip_auth)
      request[:success].should    be_truthy
      request[:payments].size.should == 1
    end

    it "should get details of a payment" do
      request = Moip::Assinaturas::Payment.details(7, moip_auth: $custom_moip_auth)
      request[:success].should        be_truthy
      request[:payment][:id].should   == 7
    end

    it "should raise exception from invalid oauth" do
      expect{ Moip::Assinaturas::Payment.details(7, moip_auth: { oauth: {accessToken: "sefghjrs"}, sandbox: true})}.to raise_error  Moip::Assinaturas::MissingTokenError
    end

    it "shoul raise exception from nil oauth" do
      expect{ Moip::Assinaturas::Payment.details(7, moip_auth: { oauth: {accessToken: ""}, sandbox: true })}.to raise_error Moip::Assinaturas::MissingTokenError
    end
  end
end