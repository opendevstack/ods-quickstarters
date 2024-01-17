import os
import boto3
import json

def get_terraform_outputs():
    with open('terraform_outputs.json') as file:
      output_json = json.load(file)

    return output_json

def setup_test_database():
    tf_outputs = get_terraform_outputs()
    aws_region = tf_outputs["aws_region"]["value"]
    client = boto3.client('athena', region_name=aws_region)
    created = create_database(client)
    if created:
        address_table_creation_query(client)
        person_table_creation_query(client)


def create_database(client):

    query = "CREATE DATABASE greatexpectationsdbtest"
    response = client.start_query_execution(
        QueryString=query,
        ResultConfiguration={
          'OutputLocation': 's3://gxdbtests3/db_test_outputs/',
        }
    )
    print('Database created.')
    return 1

def address_table_creation_query(client):
    query = """
        CREATE EXTERNAL TABLE IF NOT EXISTS `address`(
          `_hoodie_commit_time` string COMMENT '',
          `_hoodie_commit_seqno` string COMMENT '',
          `_hoodie_record_key` string COMMENT '',
          `_hoodie_partition_path` string COMMENT '',
          `_hoodie_file_name` string COMMENT '',
          `address_id` decimal(10,0) COMMENT '',
          `address_line_1` string COMMENT '',
          `address_line_2` string COMMENT '',
          `address_line_3` string COMMENT '',
          `address_line_4` string COMMENT '',
          `address_owner_key_1` string COMMENT '',
          `address_owner_key_2` string COMMENT '',
          `address_owner_key_3` string COMMENT '',
          `address_owner_key_4` string COMMENT '',
          `address_owner_key_5` string COMMENT '',
          `address_type_code` decimal(6,0) COMMENT '',
          `country_code` string COMMENT '',
          `last_updated_date` timestamp COMMENT '',
          `owner` string COMMENT '',
          `post_zip_code` string COMMENT '',
          `primary_address_flag` string COMMENT '',
          `province_county` string COMMENT '',
          `province_county_code` string COMMENT '',
          `table_short_name` string COMMENT '',
          `town_city` string COMMENT '',
          `updated_during_mon_visit_by` decimal(6,0) COMMENT '',
          `update_count` decimal(8,0) COMMENT '',
          `aud_action_flag` string COMMENT '',
          `aud_date_changed` timestamp COMMENT '',
          `aud_personnel_no` decimal(6,0) COMMENT '',
          `time_zone_offset` decimal(4,2) COMMENT '',
          `transaction_no` decimal(38,0) COMMENT '',
          `ingestion_timestamp` bigint COMMENT '',
          `pr_tab_hist_hkey` string COMMENT '',
          `pr_tab_hkey` string COMMENT '',
          `audit_id` string COMMENT '',
          `audit_task_id` string COMMENT '',
          `int_tec_from_dt` date COMMENT '',
          `int_tec_to_dt` date COMMENT '',
          `curr_flg` int COMMENT '',
          `del_flg` int COMMENT '')
        PARTITIONED BY (
          `modulekey` bigint COMMENT '')
        ROW FORMAT SERDE
          'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
        WITH SERDEPROPERTIES (
          'hoodie.query.as.ro.table'='false',
          'path'='s3://gxdbtests3/clean/address')
        STORED AS INPUTFORMAT
          'org.apache.hudi.hadoop.HoodieParquetInputFormat'
        OUTPUTFORMAT
          'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
        LOCATION
          's3://gxdbtests3/clean/address'
        TBLPROPERTIES (
          'last_commit_time_sync'='20230725080610371',
          'spark.sql.create.version'='3.3.0-amzn-1',
          'spark.sql.sources.provider'='hudi',
          'spark.sql.sources.schema.numPartCols'='1',
          'spark.sql.sources.schema.numParts'='1',
          'spark.sql.sources.schema.part.0'='{\"type\":\"struct\",\"fields\":[{\"name\":\"_hoodie_commit_time\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"_hoodie_commit_seqno\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"_hoodie_record_key\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"_hoodie_partition_path\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"_hoodie_file_name\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_id\",\"type\":\"decimal(10,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_line_1\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_line_2\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_line_3\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_line_4\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_owner_key_1\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_owner_key_2\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_owner_key_3\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_owner_key_4\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_owner_key_5\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"address_type_code\",\"type\":\"decimal(6,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"country_code\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"last_updated_date\",\"type\":\"timestamp\",\"nullable\":true,\"metadata\":{}},{\"name\":\"owner\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"post_zip_code\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"primary_address_flag\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"province_county\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"province_county_code\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"table_short_name\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"town_city\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"updated_during_mon_visit_by\",\"type\":\"decimal(6,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"update_count\",\"type\":\"decimal(8,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"aud_action_flag\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"aud_date_changed\",\"type\":\"timestamp\",\"nullable\":true,\"metadata\":{}},{\"name\":\"aud_personnel_no\",\"type\":\"decimal(6,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"time_zone_offset\",\"type\":\"decimal(4,2)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"transaction_no\",\"type\":\"decimal(38,0)\",\"nullable\":true,\"metadata\":{}},{\"name\":\"ingestion_timestamp\",\"type\":\"long\",\"nullable\":true,\"metadata\":{}},{\"name\":\"pr_tab_hist_hkey\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"pr_tab_hkey\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"audit_id\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"audit_task_id\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"int_tec_from_dt\",\"type\":\"date\",\"nullable\":true,\"metadata\":{}},{\"name\":\"int_tec_to_dt\",\"type\":\"date\",\"nullable\":true,\"metadata\":{}},{\"name\":\"curr_flg\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}},{\"name\":\"del_flg\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}},{\"name\":\"moduleKey\",\"type\":\"long\",\"nullable\":true,\"metadata\":{}}]}',
          'spark.sql.sources.schema.partCol.0'='moduleKey',
          'transient_lastDdlTime'='1690272434')
    """
    execute_query(client, query)

def person_table_creation_query(client):
    query = """
        CREATE EXTERNAL TABLE IF NOT EXISTS person (
            name VARCHAR(50),
            surname VARCHAR(50),
            age INT,
            location VARCHAR(100)
        )
        ROW FORMAT DELIMITED
        FIELDS TERMINATED BY ','
        LOCATION 's3://gxdbtests3/clean/person';
    """
    execute_query(client, query)

    query_insert_data = """
        INSERT INTO person (name, surname, age, location)
            VALUES
                ('John', 'Doe', 25, 'New York'),
                ('Jane', 'Smith', 32, 'London'),
                ('Michael', 'Johnson', 45, 'Berlin');
    """
    execute_query(client, query_insert_data)


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
  setup_test_database()

if __name__ == "__main__":
  main()
