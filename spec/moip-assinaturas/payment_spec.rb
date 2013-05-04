# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Payment do

  before(:all) do

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/invoices/13/payments", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_payments.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@wwww.moip.com.br/assinaturas/v1/payments/6", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_payment.json'),
      status: [200, 'OK']
    )

  end

  it "should get all payments from a invoice" do
    request = Moip::Assinaturas::Payment.list(13)
    request[:success].should    be_true
    request[:payments].size.should == 1
  end

  it "should get details of a payment" do
    request = Moip::Assinaturas::Payment.details(6)
    request[:success].should        be_true
    request[:payment][:id].should   == 6
  end

end