# Precondition

* Does not use Exrm
* Does not use database and Ecto
* Does not use brunch

# Build platform

## Install awsebcli

```bash
$ brew install awsebcli
# or
$ pip install awsebcli
```

## Clone template source

```bash
$ git clone https://github.com/sonodar/elasticbeanstalk-phoenix-platform.git
$ cd elasticbeanstalk-phoenix-platform
```

## Build

Initialize platform.

```bash
$ ebp init -r ap-northeast-1

Enter Platform Name
(default is "elasticbeanstalk-phoenix-platform"):
```

Create platform.

```bash
$ ebp create
INFO: createPlatform is starting.
INFO: Initiated platform version creation for 'elasticbeanstalk-phoenix-platform/1.0.0'.
INFO: Creating Packer builder environment 'eb-custom-platform-builder-packer'.
INFO: Starting Packer building task.
INFO: Creating CloudWatch log group '/aws/elasticbeanstalk/platform/elasticbeanstalk-phoenix-platform'.
INFO: Downloading EB bootstrap script https://s3-ap-northeast-1.amazonaws.com/elasticbeanstalk-env-resources-ap-northeast-1/stalks/eb_packer_4.0.1.54.0/skeleton/lib/bootstrap/amazon/eb-user-data...
INFO: Downloading EB bootstrap script https://s3-ap-northeast-1.amazonaws.com/elasticbeanstalk-env-resources-ap-northeast-1/stalks/eb_packer_4.0.1.54.0/skeleton/lib/bootstrap/amazon/eb-bootstrap.sh...
INFO: Injecting script awseb-bootstrap/eb-bootstrap.sh into Packer template...
INFO: Invoking 'packer build'...
INFO: HVM AMI builder output will be in this color.
INFO:
INFO: ==> HVM AMI builder: Prevalidating AMI Name...
# ... omission ...
INFO: 'packer build' finished.
INFO: Successfully built AMI(s): 'ami-93a5fef4' for 'arn:aws:elasticbeanstalk:ap-northeast-1:xxxxxxxxxxxx:platform/elasticbeanstalk-phoenix-platform/1.0.0'
INFO: Creating CloudWatch log group '/aws/elasticbeanstalk/platform/elasticbeanstalk-phoenix-platform'.
INFO: Successfully built AMI(s): 'ami-93a5fef4' for 'arn:aws:elasticbeanstalk:ap-northeast-1:xxxxxxxxxxxx:platform/elasticbeanstalk-phoenix-platform/1.0.0'
INFO: Packer built AMIs: ami-93a5fef4.
INFO: Successfully created platform version 'elasticbeanstalk-phoenix-platform/1.0.0'.
```

Confirm.

```bash
$ ebp list
arn:aws:elasticbeanstalk:ap-northeast-1:xxxxxxxxxxxx:platform/elasticbeanstalk-phoenix-platform/1.0.0  Status: Ready
```

# Create sample project

for Mac.

```bash
brew install elixir
mix local.hex
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
mix phoenix.new eb_phoenix --no-brunch --no-ecto
cd eb_phoenix
```

Answer `y`

```
Fetch and install dependencies? [Yn] y
```

Try access http://localhost:4000

```bash
mix phoenix.server # Stop Ctrl+C 2 times
```

![Hello-EbPhoenix.png](https://qiita-image-store.s3.amazonaws.com/0/17735/27dc283f-6355-47cb-c392-6b1a61b37d7b.png)

# Deploy sample application with Custom Platform

Initialize with `eb init` command, select `13) Custom Platform`.

```bash
$ cd eb_phoenix
$ eb init -r ap-northeast-1
Select an application to use
1) Custom Platform Builder
2) [ Create new Application ]
(default is 2):

Enter Application Name
(default is "eb_phoenix"): eb-phoenix

Select a platform.
1) Node.js
2) PHP
3) Python
4) Ruby
5) Tomcat
6) IIS
7) Docker
8) Multi-container Docker
9) GlassFish
10) Go
11) Java
12) Packer
13) Custom Platform
(default is 1): 13

Select a platform.
1) elasticbeanstalk-platform-phoenix (Owned by: xxxxxxxxxxxx)
(default is 1): 1
Do you want to set up SSH for your instances?
(Y/n): Y

Select a keypair.
1) sonodar
2) [ Create new KeyPair ]
(default is 1): 1
```

Create ElasticBeanstalk Environment with `eb create` command.
`-s` is Single node option.

```bash
$ eb create -s
Enter Environment Name
(default is eb-phoenix-dev): eb-phoenix-dev
Enter DNS CNAME prefix
(default is eb-phoenix-dev): eb-phoenix-dev
Creating application version archive "app-84db-170327_132118".
Uploading eb-phoenix/app-84db-170327_132118.zip to S3. This may take a while.
Upload Complete.
Application eb-phoenix has been created.
Environment details for: eb-phoenix-dev
  Application name: eb-phoenix
  Region: ap-northeast-1
  Deployed Version: app-84db-170327_132118
  Environment ID: e-7fshvxwyad
  Platform: arn:aws:elasticbeanstalk:ap-northeast-1:xxxxxxxxxxxx:platform/elasticbeanstalk-platform-phoenix/1.0.0
  Tier: WebServer-Standard
  CNAME: eb-phoenix-dev.ap-northeast-1.elasticbeanstalk.com
  Updated: 2017-03-27 04:21:21.816000+00:00
Printing Status:
INFO: createEnvironment is starting.
INFO: Using elasticbeanstalk-ap-northeast-1-xxxxxxxxxxxx as Amazon S3 storage bucket for environment data.
INFO: Created EIP: 52.197.66.130
INFO: Created security group named: awseb-e-7fshvxwyad-stack-AWSEBSecurityGroup-1T9MF5U46H463
INFO: Waiting for EC2 instances to launch. This may take a few minutes.
INFO: Adding instance 'i-065353dcfcb113901' to your environment.
INFO: Successfully launched environment: eb-phoenix-dev
```

# Template commentary

TODO:

## Tips

* Understand the ElasticBeanstalk deployment sequence
* Use Upstart for Daemon / Service of Phoenix application
* Parastic of ElasticBeanstalk's environment and output to file
* I created Erlang's rpm for this template

# Caution

## `ebp` command is not work, when stopped `Custom Platform Builder` environment.

If `Custom Platform Builder` environment stopped, then this output.

```
ERROR: TypeError :: cannot concatenate 'str' and 'list' objects
```

## If you were not allowed `CreateRole` action, `ebp create` is fail

Attach this policy.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantCreateRole",
            "Action": [
                "iam:Create*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

Or create roll in advance.

```json:Trusted policy
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

```json:Inline policy(EB_Custom_Platform_Builder_Policy)
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PackerEC2Access",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeypair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "BucketAccess",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::elasticbeanstalk-*",
                "arn:aws:s3:::elasticbeanstalk-*/*"
            ]
        },
        {
            "Sid": "CloudWatchLogsAccess",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/platform/*"
        }
    ]
}
```
