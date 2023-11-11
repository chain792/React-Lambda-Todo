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

def scan_items
  response = todo_table.scan()
rescue Aws::DynamoDB::Errors::ServiceError => e
  puts("Couldn't scan for todos")
  puts("\t#{e.code}: #{e.message}")
  raise
else
  response.items.sort_by { |item| item['id'] }
end

def lambda_handler(event:, context:)
    todos = scan_items
    { 
        statusCode: 200,
        body: JSON.generate(todos), 
        headers: {
            "Access-Control-Allow-Origin": "http://localhost:3000"
        }
        
    }
end
