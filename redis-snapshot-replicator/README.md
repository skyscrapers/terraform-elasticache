TODO manual

Elasticache needs to have account permissions to the S3 bucket, without this explicit access, it is unable to store backups in S3. In this link, there is more info : https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-exporting.html#backups-exporting-grant-access

These are the steps you have to take

Open the S3 console and go to newly created bucket

Choose Permissions.

Choose Access Control List.

Under Access for other AWS accounts, choose + Add account.

All other regions:

540804c33a284a299d2547575ce1010f2312ef3da9b3a053c8bc45bf233e4353
Set the permissions on the bucket by choosing Yes for:

List objects

Write objects

Read bucket permissions

Choose Save.

