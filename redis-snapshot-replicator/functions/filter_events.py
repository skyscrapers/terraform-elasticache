import boto3
import botocore
import OS

redis_topic_arn = os.environ['SNS_TOPIC']


print('Loading function')

def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    if "Snapshot succeeded" in message
        sns = boto3.client('sns')
        try:
            response = sns.publish(
                TopicArn=redis_topic_arn,    
                Message=message,
                MessageAttributes={
                    'event_type': {
                       'DataType': 'string',
                       'StringValue': 'snapshot_succeeded'
                    }
                }     
            )
        except botocore.exceptions.ClientError as e:
            raise Exception("Could not publis SNS message: %s" % e)

