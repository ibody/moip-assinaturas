module Moip::Assinaturas
  class Webhooks
    attr_accessor :model, :event, :date, :env, :resource

    class << self
      def build(json)
        object = new
        object.model    = get_model(json['event'])
        object.event    = get_event(json['event'])
        object.date     = json['date']
        object.env      = json['env']
        object.resource = json['resource']

        object
      end

      private
      def get_model(event)
        event.split(".")[0]
      end

      def get_event(event)
        event.split(".")[1]
      end
    end
  end
end