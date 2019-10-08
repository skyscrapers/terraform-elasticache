import boto3
import botocore
import os

target_bucket = os.environ['TARGET_BUCKET'] 

print('Loading function')

def lambda_handler(event, context): 

    source = boto3.client('elasticache')

    message = event['Records'][0]['Sns']['Message']

    if "Snapshot succeeded" in message

        source_snap = ''.join([i for i in message.split('\'') if 'snapshot-' in i])
        
        try:
            response = source.copy_snapshot(SourceSnapshotName=source_snap,TargetSnapshotName=source_snap,TargetBucket=target_bucket)
            print('Will Copy %s to bucket %s' % (source_snap, target_bucket))
        except botocore.exceptions.ClientError as e:
            raise Exception("Could not issue copy command: %s" % e)
