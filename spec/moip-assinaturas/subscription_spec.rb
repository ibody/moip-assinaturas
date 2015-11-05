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

    @subscription2 = {
      code: "assinatura2",
      amount: "100",
      plan: {
        code: "plano2"
      },
      customer: {
        code: "19"
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
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions?filters=status::eq(ACTIVE)",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_subscriptions_queried.json'),
      status: [200, 'OK']
    )    

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_subscription.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/not_found",
      body: '',
      status: [404, 'Not found']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/activate",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/suspend",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/cancel",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :post,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions?new_customer=false",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'create_subscription.json'),
      status: [201, 'CREATED']
    )

    # UPDATE SUBSCRIPTION
    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'list_subscriptions.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions/assinatura2",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'details_subscription.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions/assinatura2/activate",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions/assinatura2/suspend",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/subscriptions/assinatura2/cancel",
      body: '',
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :delete,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/subscriptions/assinatura1/coupon",
      body: File.join(File.dirname(__FILE__), '..', 'fixtures', 'delete_coupon_subscription.json'),
      status: [200, 'OK']
    )
  end

  it "should create a new subscription" do
    request = Moip::Assinaturas::Subscription.create(@subscription)
    request[:success].should be_truthy
    request[:subscription][:code].should == 'ass_homolog_72'
  end

  it "should update a subscription" do
    request = Moip::Assinaturas::Subscription.update(@subscription[:code], { amount: 9990 })
    request[:success].should be_truthy
  end

  it "should list all subscriptions" do
    request = Moip::Assinaturas::Subscription.list
    request[:success].should             be_truthy
    request[:subscriptions].size.should  == 1
  end

    it "should list subscriptions using query param" do
    request = Moip::Assinaturas::Subscription.list(query_params: 'filters=status::eq(ACTIVE)')
    request[:success].should             be_truthy
    request[:subscriptions].size.should  == 3
  end

  describe 'subscription details' do
    it "should get the subscription details" do
      request = Moip::Assinaturas::Subscription.details('assinatura1')
      request[:success].should                be_truthy
      request[:subscription][:code].should == 'assinatura1'
    end

    it 'should return not found when the subscription does not exist' do
      request = Moip::Assinaturas::Subscription.details('not_found')
      request[:success].should                be_falsey
      request[:message].should == 'not found'
    end
  end

  it "should suspend a subscription" do
    request = Moip::Assinaturas::Subscription.suspend('assinatura1')
    request[:success].should be_truthy
  end

  it "should reactive a subscription" do
    request = Moip::Assinaturas::Subscription.activate('assinatura1')
    request[:success].should be_truthy
  end

  it "should suspend a subscription" do
    request = Moip::Assinaturas::Subscription.suspend('assinatura1')
    request[:success].should be_truthy
  end

  it "should cancel a subscription" do
    request = Moip::Assinaturas::Subscription.cancel('assinatura1')
    request[:success].should be_truthy
  end

  it "should delete a coupon of subscription" do
    request = Moip::Assinaturas::Subscription.delete_coupon('assinatura1')
    request[:success].should be_truthy
  end

  context "Trial" do
    it "should get the subscription details with trial" do
      request = Moip::Assinaturas::Subscription.details('assinatura1')
      expect(request[:subscription][:trial]).to have_valid_trial_dates
    end
  end

  context "Custom Authentication" do
    it "should create a new subscription from a custom moip account" do
      request = Moip::Assinaturas::Subscription.create(@subscription, false, moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
      request[:subscription][:code].should == 'ass_homolog_72'
    end

    it "should list all subscriptions from a custom moip account" do
      request = Moip::Assinaturas::Subscription.list(moip_auth: $custom_moip_auth)
      request[:success].should             be_truthy
      request[:subscriptions].size.should  == 1
    end

    it "should get the subscription details from a custom moip account" do
      request = Moip::Assinaturas::Subscription.details('assinatura2', moip_auth: $custom_moip_auth)
      request[:success].should                be_truthy
      request[:subscription][:code].should == 'assinatura2'
    end

    it "should suspend a subscription from a custom moip account" do
      request = Moip::Assinaturas::Subscription.suspend('assinatura2', moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
    end

    it "should reactive a subscription from a custom moip account" do
      request = Moip::Assinaturas::Subscription.activate('assinatura2', moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
    end

    it "should cancel a subscription from a custom moip account" do
      request = Moip::Assinaturas::Subscription.cancel('assinatura2', moip_auth: $custom_moip_auth)
      request[:success].should be_truthy
    end
  end

end
