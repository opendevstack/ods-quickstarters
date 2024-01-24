import boto3
import json

"""

This is an example of what you could do as a post-requisite. In the pre_requistie.py. It is intended to be used as a clean up step
to remove any data set, or reset your system to its initial state.

In this scenario we deployed on the prerequisites an athena dabase that would be tested.
Now, in this post_requisite.py we delete the database and the tables inside of it.

"""


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
    q_delete_db = "DROP DATABASE IF EXISTS greatexpectationsdb"
    execute_query(client, q_delete_address_table)
    execute_query(client, q_delete_person_table)
    execute_query(client, q_delete_db)

def execute_query(client, query):
    tf_outputs = get_terraform_outputs()
    bucket_name = tf_outputs["bitbucket_s3bucket_name"]["value"]
    response = client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': 'greatexpectationsdb'
        },
        ResultConfiguration={
            'OutputLocation': f's3://{bucket_name}/db_test_outputs/',
        }
    )
    print("Query execution ID: ", response['QueryExecutionId'])


def remove_unnecesarry_objects_s3src():
  tf_outputs = get_terraform_outputs()
  bucket_name = tf_outputs["bitbucket_s3bucket_name"]["value"]
  s3 = boto3.resource('s3')
  bucket = s3.Bucket(bucket_name)
  for obj in bucket.objects.all():
    if not obj.key.endswith('.zip'):
      obj.delete()




def main():
  delete_test_database()
  remove_unnecesarry_objects_s3src()


if __name__ == "__main__":
  main()
