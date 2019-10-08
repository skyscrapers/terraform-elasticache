import boto3
import botocore
import datetime
import re
import os

iam = boto3.client('iam')  
instances = os.environ['DB_INSTANCES']  
target_bucket = os.environ['TARGET_BUCKET'] 

print('Loading function')

def byTimestamp(snap):  
    if 'SnapshotCreateTime' in snap:
        return datetime.datetime.isoformat(snap['SnapshotCreateTime'])
    else:
        return datetime.datetime.isoformat(datetime.datetime.now())

def lambda_handler(event, context): 

    source = boto3.client('elasticache')

    message = event['Records'][0]['Sns']['Message']

    if "Snapshot succeeded" in message

        for instance in instances.split(','):
            source_snaps = source.describe_snapshots(CacheClusterId=instance)['Snapshots']
            source_snap = sorted(source_snaps, key=byTimestamp, reverse=True)[0]['SnapshotName']
        
        try:
            response = source.copy_snapshot(SourceSnapshotName=source_snap,TargetSnapshotName=source_snap,TargetBucket=target_bucket)
                print('Will Copy %s to bucket %s' % (source_snap, target_bucket))
            except botocore.exceptions.ClientError as e:
                raise Exception("Could not issue copy command: %s" % e)
