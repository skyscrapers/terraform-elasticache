import boto3
import botocore
import os
import datetime
import re

target_bucket = os.environ['TARGET_BUCKET'] 
instances = os.environ['DB_INSTANCES']

print('Loading function')

def byTimestamp(snap):
    return datetime.datetime.isoformat(snap['NodeSnapshots'][0]['SnapshotCreateTime'])

def lambda_handler(event, context): 

    source = boto3.client('elasticache')

    message = event['Records'][0]['Sns']['Message']
    print(message)
    if "SnapshotComplete" in message:

        for instance in instances.split(','):
            paginator = source.get_paginator('describe_snapshots')
            page_iterator = paginator.paginate(CacheClusterId=instance)
            snapshots = []
            for page in page_iterator:
                snapshots.extend(page['Snapshots'])
            source_snap = sorted(snapshots, key=byTimestamp, reverse=True)[0]['SnapshotName']            
            print(source_snap)
        try:
            response = source.copy_snapshot(SourceSnapshotName=source_snap,TargetSnapshotName=source_snap,TargetBucket=target_bucket)
            print('Will Copy %s to bucket %s' % (source_snap, target_bucket))
        except botocore.exceptions.ClientError as e:
            raise Exception("Could not issue copy command: %s" % e)            
