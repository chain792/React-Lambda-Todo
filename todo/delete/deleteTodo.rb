require 'json'
require 'aws-sdk-dynamodb'

def client
  @client ||= Aws::DynamoDB::Client.new
end

def dynamo_resource
  @dynamo_resource ||= Aws::DynamoDB::Resource.new(client: client)
end

def todo_table
  @todo_table ||= dynamo_resource.table('todo')
end

def delete_item(id)
  todo_table.delete_item(key: {"id" => id},)
rescue Aws::DynamoDB::Errors::ServiceError => e
  puts("Couldn't delete todos")
  puts("\t#{e.code}: #{e.message}")
  raise
end

def lambda_handler(event:, context:)
  id = event["queryStringParameters"]["id"].to_f.to_i
  delete_item(id)
  { 
    statusCode: 200,
    headers: {
        "Access-Control-Allow-Origin": "http://localhost:3000"
    }
  }
end
