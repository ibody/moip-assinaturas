module Moip::Assinaturas
  class Webhooks
    attr_accessor :model, :event, :date, :env, :resource, :events

    class << self
      def build(json)
        object = new
        object.model    = get_model(json['event'])
        object.event    = get_event(json['event'])
        object.events   = {}
        object.date     = json['date']
        object.env      = json['env']
        object.resource = json['resource']

        object
      end

      def listen(params, &block)
        hook = build(params)
        yield hook
        hook.run
      end

      private
      def get_model(event)
        event.split(".")[0]
      end

      def get_event(event)
        event.split(".")[1]
      end
    end

    def on(model, event, &block)
      unless events[model]
        events[model] = {}
      end

      unless events[model][event]
        events[model][event] = []
      end

      events[model][event] << block
    end

    def run
      events[model][event].each { |action| action.call } if (events[model] && events[model][event])
    end
  end
end