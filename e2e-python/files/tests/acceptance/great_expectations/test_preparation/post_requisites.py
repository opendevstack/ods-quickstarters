import boto3
import json

def get_terraform_outputs():
    with open('terraform_outputs.json') as file:
      output_json = json.load(file)

    return output_json

def delete_test_database():
    tf_outputs = get_terraform_outputs()
    aws_region = tf_outputs["aws_region"]["value"]
    client = boto3.client('athena', region_name=aws_region)
    q_delete_address_table = "DROP TABLE IF EXISTS address"
    q_delete_person_table = "DROP TABLE IF EXISTS person"
    q_delete_db = "DROP DATABASE IF EXISTS greatexpectationsdbtest"
    execute_query(client, q_delete_address_table)
    execute_query(client, q_delete_person_table)
    execute_query(client, q_delete_db)

def execute_query(client, query):
    response = client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': 'greatexpectationsdbtest'
        },
        ResultConfiguration={
            'OutputLocation': 's3://gxdbtests3/db_test_outputs/',
        }
    )
    print("Query execution ID: ", response['QueryExecutionId'])


def main():
  delete_test_database()


if __name__ == "__main__":
  main()
