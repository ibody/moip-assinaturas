# coding: utf-8
require 'spec_helper'

describe Moip::Assinaturas::Webhooks do

  let!(:json) do

    {
      'event' => 'model.event',
      'date' => '28/12/2012 15:38:46',
      'env' => 'generic_env',
      'resource' => {
        'test' => 'test generic resource'
      }
    }
  end

  describe '.build(json)' do
    subject(:hook) { Moip::Assinaturas::Webhooks.build(json) }

    its(:model) { should eq('model') }
    its(:event) { should eq('event') }
    its(:events) { should eq({}) }

    its(:date) { should eq('28/12/2012 15:38:46') }

    its(:env) { should eq('generic_env') }
    its(:resource) { should eq({ 'test' => 'test generic resource' }) }
  end

  describe '#on(model, event, &block)' do
    let!(:model) { 'model' }
    let!(:event) { 'event' }
    let!(:block) { lambda { } }

    subject(:hook) { Moip::Assinaturas::Webhooks.build(json) }

    it "should adding this block to events" do
      hook.on(model, event, &block)
      hook.events[model][event].should eq([block])
    end
  end

  describe '#run' do
    let!(:model) { 'model' }
    let!(:event) { 'event' }
    let!(:block) { lambda { } }

    subject(:hook) { Moip::Assinaturas::Webhooks.build(json) }

    it 'should call block once' do
      hook.on(model, event, &block)

      block.should_receive(:call).once

      hook.run
    end
  end
end