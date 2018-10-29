import boto3  
import datetime 
import os

instances = os.environ['DB_INSTANCES']
iam = boto3.client('iam')
print('Loading function')

def lambda_handler(event, context):  
    source = boto3.client('elasticache')

    for instance in instances.split(','):
        now = datetime.datetime.now()
        db_snapshot_name = now.strftime('%Y-%m-%d-%H-%M')
        response = source.create_snapshot(CacheClusterId=instance,SnapshotName='snapshot-'+db_snapshot_name)
