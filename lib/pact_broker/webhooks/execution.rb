require 'sequel'
require 'pact_broker/db'
require 'pact_broker/repositories/helpers'

module PactBroker
  module Webhooks
    class Execution < Sequel::Model(
      Sequel::Model.db[:webhook_executions].select(
        Sequel[:webhook_executions][:id],
        :triggered_webhook_id,
        :success,
        :logs,
        Sequel[:webhook_executions][:created_at])
      )

      plugin :timestamps

      dataset_module do
        include PactBroker::Repositories::Helpers
      end

      associate(:many_to_one, :triggered_webhook, :class => "PactBroker::Webhooks::TriggeredWebhook", :key => :triggered_webhook_id, :primary_key => :id)

      def <=> other
        comp = created_date <=> other.created_date
        comp = id <=> other.id if comp == 0
        comp
      end
    end
  end
end

# Table: webhook_executions
# Columns:
#  id                   | integer                     | PRIMARY KEY DEFAULT nextval('webhook_executions_id_seq'::regclass)
#  triggered_webhook_id | integer                     |
#  success              | boolean                     | NOT NULL
#  logs                 | text                        |
#  created_at           | timestamp without time zone | NOT NULL
# Indexes:
#  webhook_executions_pkey | PRIMARY KEY btree (id)
# Foreign key constraints:
#  webhook_executions_consumer_id_fkey          | (consumer_id) REFERENCES pacticipants(id)
#  webhook_executions_pact_publication_id_fkey  | (pact_publication_id) REFERENCES pact_publications(id)
#  webhook_executions_provider_id_fkey          | (provider_id) REFERENCES pacticipants(id)
#  webhook_executions_triggered_webhook_id_fkey | (triggered_webhook_id) REFERENCES triggered_webhooks(id)
#  webhook_executions_webhook_id_fkey           | (webhook_id) REFERENCES webhooks(id)
