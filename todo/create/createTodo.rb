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

def sequence_table
  @sequence_table ||= dynamo_resource.table('sequence')
end

def add_item(id, title)
  todo_table.put_item(
    item: {
      id: id,
      title: title,
      isCompleted: false
    }
  )
rescue Aws::DynamoDB::Errors::ServiceError => e
  puts("Couldn't add todo id: #{id}, title: #{title}")
  puts("\t#{e.code}: #{e.message}")
  raise
end

def get_next_id
  response = sequence_table.update_item(
    key: { tablename: 'todo' },
    update_expression: "add seq :r",
    expression_attribute_values: { ":r" => 1 },
    return_values: "UPDATED_NEW"
  )
rescue Aws::DynamoDB::Errors::ServiceError => e
  puts("Couldn't update sequence")
  puts("\t#{e.code}: #{e.message}")
  raise
else
  response.attributes["seq"]
end

def lambda_handler(event:, context:)
  next_id = get_next_id
  body = JSON.parse(event["body"])
  title = body["title"]
  add_item(next_id, title)
  { 
    statusCode: 200,
    headers: {
        "Access-Control-Allow-Origin": "http://localhost:3000"
    }
  }
end
