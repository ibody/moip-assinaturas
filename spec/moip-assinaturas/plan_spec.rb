# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Plan do

  before(:all) do
    @plan = {
      code: "plano01",
      name: "Plano Especial",
      description: "Descrição do Plano Especial",
      amount: 990,
      setup_fee: 500,
      max_qty: 1,
      interval: {
        length: 1,
        unit: "MONTH"
      },
      billing_cycles: 12,
      trial: {
        enabled: true,
        days: 10
      }
    }

    @plan2 = {
      code: "plano02",
      name: "Plano Especial 2",
      description: "Descrição do Plano Especial 2",
      amount: 490,
      setup_fee: 200,
      max_qty: 2,
      interval: {
        length: 3,
        unit: "MONTH"
      },
      billing_cycles: 12,
      trial: {
        enabled: true,
        days: 15
      }
    }

    FakeWeb.register_uri(
      :post,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'create_plan.json'),
      status: [201, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'list_plans.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans/plano01",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'details_plan.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans/not_found",
      body: '',
      status: [404, 'Not found']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN:KEY@api.moip.com.br/assinaturas/v1/plans/plano01",
      body:   "",
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :post,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/plans",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication', 'create_plan.json'),
      status: [201, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/plans",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication',  'list_plans.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :get,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/plans/plano02",
      body:   File.join(File.dirname(__FILE__), '..', 'fixtures', 'custom_authentication',  'details_plan.json'),
      status: [200, 'OK']
    )

    FakeWeb.register_uri(
      :put,
      "https://TOKEN2:KEY2@api.moip.com.br/assinaturas/v1/plans/plano02",
      body:   "",
      status: [200, 'OK']
    )
  end

  it "should can create a new plan" do
    request = Moip::Assinaturas::Plan.create(@plan)
    request[:success].should      be_truthy
    request[:plan][:code].should  == 'plano01'
  end

  it "should list all plans" do
    request = Moip::Assinaturas::Plan.list
    request[:success].should    be_truthy
    request[:plans].size.should == 1
  end

  describe 'plan details' do
    it "should get details from a plan" do
      request = Moip::Assinaturas::Plan.details('plano01')
      request[:success].should      be_truthy
      request[:plan][:code].should  == 'plano01'
    end

    it 'should return not found when a plan does not exist' do
      request = Moip::Assinaturas::Plan.details('not_found')
      request[:success].should      be_falsey
      request[:message].should  == 'not found'
    end
  end

  it "should update an existing plan" do
    request = Moip::Assinaturas::Plan.update(@plan)
    request[:success].should      be_truthy
  end

  context "Trial" do
    it "should get details from a plan with trial" do
      request = Moip::Assinaturas::Plan.details('plano01')
      expect(request[:plan][:trial][:days]).to eq 10
      expect(request[:plan][:trial][:enabled]).to be_truthy
    end
  end

  context "Custom Authentication" do
    it "should create a new plan in other moip account" do
      request = Moip::Assinaturas::Plan.create(@plan2, moip_auth: $custom_moip_auth)
      request[:success].should      be_truthy
      request[:plan][:code].should  == 'plano02'
    end

    it "should list all plans from other moip account" do
      request = Moip::Assinaturas::Plan.list(moip_auth: $custom_moip_auth)
      request[:success].should    be_truthy
      request[:plans].size.should == 1
    end

    it "should get details from a plan of other moip account" do
      request = Moip::Assinaturas::Plan.details('plano02', moip_auth: $custom_moip_auth)
      request[:success].should      be_truthy
      request[:plan][:code].should  == 'plano02'
    end

    it "should update an existing plan of other moip account" do
      request = Moip::Assinaturas::Plan.update(@plan2, moip_auth: $custom_moip_auth)
      request[:success].should      be_truthy
    end
  end

end
