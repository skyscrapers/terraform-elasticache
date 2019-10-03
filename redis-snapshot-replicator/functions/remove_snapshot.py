import boto3
import botocore
import datetime
import re
import os

instances = os.environ['DB_INSTANCES']  
duration = os.environ['RETENTION']

print('Loading function')

def lambda_handler(event, context): 

    source = boto3.client('elasticache')

    for instance in instances.split(','):
        paginator = source.get_paginator('describe_snapshots')
        page_iterator = paginator.paginate(CacheClusterId=instance)
        snapshots = []
        for page in page_iterator:
            snapshots.extend(page['Snapshots'])
        for snapshot in snapshots:
            create_ts = snapshot['SnapshotCreateTime'].replace(tzinfo=None)
            if create_ts < datetime.datetime.now() - datetime.timedelta(days=int(duration)):        
                try:
                    response = source.delete_snapshot(SnapshotName=snapshot['SnapshotName'])
                    print('Will remove %s from the source backups' % (source_snap))
                except botocore.exceptions.ClientError as e:
                    raise Exception("Could not issue remove command: %s" % e)
