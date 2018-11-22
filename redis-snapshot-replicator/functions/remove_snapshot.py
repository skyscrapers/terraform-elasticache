import boto3
import botocore
import datetime
import re
import os

iam = boto3.client('iam')  
instances = os.environ['DB_INSTANCES']  

print('Loading function')

def byTimestamp(snap):  
    if 'SnapshotCreateTime' in snap:
        return datetime.datetime.isoformat(snap['SnapshotCreateTime'])
    else:
        return datetime.datetime.isoformat(datetime.datetime.now())

def lambda_handler(event, context): 

    source = boto3.client('elasticache')

    for instance in instances.split(','):
        source_snaps = source.describe_snapshots(CacheClusterId=instance)['Snapshots']
        source_snap = sorted(source_snaps, key=byTimestamp, reverse=False)[0]['SnapshotName']
        
        try:
            response = source.delete_snapshot(SnapshotName=source_snap)
            print('Will remove %s from the source backups' % (source_snap))
        except botocore.exceptions.ClientError as e:
            raise Exception("Could not issue remove command: %s" % e)
