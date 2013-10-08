# coding: utf-8
require 'spec_helper'

RSpec::Matchers.define :have_valid_trial_dates do
  match do |actual|
    (actual[:start][:day] == 27 && actual[:start][:month] == 9 && actual[:start][:year] == 2013) && 
    (actual[:end][:day] == 17 && actual[:end][:month] == 10 && actual[:end][:year] == 2013)
  end
end

describe Moip::Assinaturas::Subscription do
  
  before(:all) do
    @subscription = {
      code: "assinatura1",
      amount: "100",
      plan: {
        code: "plano1"
      },
      customer: {
        code: "18"
      }
    }

    FakeWeb.register_uri(
      :post, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions?new_customer=false", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_subscription.json'),
      status: [201, 'CREATED']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_subscriptions.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1", 
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_subscription.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/activate",
      body: 'CREATED', 
      status: [201, 'OK']
    )

    FakeWeb.register_uri(
      :put, 
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/suspend", 
      body: 'CREATED',
      status: [201, 'OK']
    )
  end

  it "should create a new subscription" do
    request = Moip::Assinaturas::Subscription.create(@subscription)
    request[:success].should be_true
    request[:subscription][:code].should == 'ass_homolog_72'
  end

  it "should list all subscriptions" do
    request = Moip::Assinaturas::Subscription.list
    request[:success].should             be_true
    request[:subscriptions].size.should  == 1
  end

  it "should get the subscription details" do
    request = Moip::Assinaturas::Subscription.details('assinatura1')
    request[:success].should                be_true
    request[:subscription][:code].should == 'assinatura1'
  end

  it "should suspend a subscription" do
    request = Moip::Assinaturas::Subscription.suspend('assinatura1')
    request[:success].should be_true
  end

  it "should reactive a subscription" do
    request = Moip::Assinaturas::Subscription.activate('assinatura1')
    request[:success].should be_true
  end

  context "Trial" do
    it "should get the subscription details with trial" do
      request = Moip::Assinaturas::Subscription.details('assinatura1')
      expect(request[:subscription][:trial]).to have_valid_trial_dates
    end
  end

end