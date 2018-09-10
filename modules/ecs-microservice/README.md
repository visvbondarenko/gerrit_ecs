# ecs-microservice

This module deploys:

* ECS task definitions for a microservice and a db:migrate job
* ECS service for maintaining the microservice running
* Auto-scaling functionality for scaling the the container desired count up and down based on CPU and memory metrics

## Arguments

| Name | Description | Required | Default |
| account\_shorthand | | yes | |
| environment | | yes | |
| project | | yes | |
| service | | yes | |
| owner | | yes | |
| expiration\_date | | yes | |
| monitor | | yes | |
| cost\_center | | yes | |
| cluster\_name | Name of ECS cluster | yes | |
| image | ECR image name to use for service | yes | |
| lb\_target\_group\_arn | Load balancer target group ARN to register service to | yes | |
| service\_cpu | Required CPU amount for service | no | 256 |
| service\_memory | Required memory amount for service | no | 256 |
| service\_working\_dir | Working directory in the container to use | no | /application |
| service\_host\_port | Container host's port to bind service to | yes | |
| service\_container\_port | Container's internal port to map to host | yes | |
| migrate\_host\_port | Migrate task's container host's port to bind task to | yes | |
| migrate\_container\_port | Migrate task's internal port to map to host | yes | |
| awslogs\_group | AWS logs group for service and migration logs | no | |
| awslogs\_region | AWS logs region for service and migration logs | no | |
| awslogs\_stream\_prefix | Prefix for AWS logs stream | no | |
| cognito\_client\_id | | no | |
| cognito\_client\_secret | | no | |
| cognito\_oauth\_endpoint | | no | |
| cognito\_oauth\_scope | | no | |
| cognito\_region | | no | |
| db\_adapter | Database adapter | no | postgresql |
| db\_database | Database name | no | |
| db\_encoding | Database encoding | no | utf8 |
| db\_host | Database host | no | |
| db\_username | Database username | no | |
| db\_password | Database password | no | |
| db\_pool | Database pool | no | |
| db\_port | Database port | no | |
| db\_master\_username | RDS admin user's username | no | |
| db\_master\_password | RDS admin user's password | no | |
| rack\_env | rack environment | no | |

### Cognito and database credential future state

Eventually cognito\_ and db\_ variables shall be removed from this module and are expected to be pulled directly by the applications from within the containers by leveraging the secrets stored in AWS Secrets Manager.

For the transitional period, this module passes secrets into the container through the task definitions and environment variables.
