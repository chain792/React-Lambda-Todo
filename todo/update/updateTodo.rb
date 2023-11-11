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

def update_item(id, isCompleted)
  response = todo_table.update_item(
    key: {"id" => id},
    update_expression: "set isCompleted = :r",
    expression_attribute_values: { ":r" => isCompleted }
  )
rescue Aws::DynamoDB::Errors::ServiceError => e
  puts("Couldn't update todos")
  puts("\t#{e.code}: #{e.message}")
  raise
end

def lambda_handler(event:, context:)
  id = event["queryStringParameters"]["id"].to_f.to_i
  body = JSON.parse(event["body"])
  isCompleted = body["isCompleted"]
  update_item(id, isCompleted)
  { 
    statusCode: 200,
    headers: {
        "Access-Control-Allow-Origin": "http://localhost:3000"
    }
  }
end
